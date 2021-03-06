#include <time.h>
#include "nifs.h"

static ERL_NIF_TERM move(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    ERL_NIF_TERM result;
    struct board* board = calloc(1, sizeof(struct board));
    struct move *move = malloc(sizeof(struct move));
    int pos, sub_board, rotation, color;

    tuple_to_board(env, argv[0], board);
    enif_get_int(env, argv[1], &pos);
    enif_get_int(env, argv[2], &color);
    enif_get_int(env, argv[3], &sub_board);
    enif_get_int(env, argv[4], &rotation);

    move->pos = (uint8_t) pos;
    move->color = (uint8_t) color;
    move->sub_board = (uint8_t) sub_board;
    move->rotation = (uint8_t) rotation;

    struct board* new_board  = board_move(board, move);
    result = make_move_result(env, new_board, move, 0);

    free(new_board);
    free(move);
    return result;
}

static ERL_NIF_TERM make_move(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
    ERL_NIF_TERM result;
    struct board* board = malloc(sizeof(struct board));
    board->color[BLACK] = 0ul;
    board->color[WHITE] = 0ul;
    struct move *move;
    int algorithm, mg, eval, color, depth, turn;

    tuple_to_board(env, argv[0], board);
    enif_get_int(env, argv[1], &algorithm);
    enif_get_int(env, argv[2], &eval);
    enif_get_int(env, argv[3], &mg);
    enif_get_int(env, argv[4], &color);
    enif_get_int(env, argv[5], &depth);
    enif_get_int(env, argv[6], &turn);

    move_generator move_generator;
    evaluation evaluation ;
    switch (mg) {
        case MOVE_GENERATOR_SORTED:
            move_generator = get_available_moves_sorted;
            break;
        case MOVE_GENERATOR_DEFAULT:
        default:
            move_generator = get_available_moves;
            break;
    }

    switch (eval) {
        case EVALUATION_BLOCK:
            evaluation = board_evaluate_block;
            break;
        case EVALUATION_STAIGHT_FIVE:
            evaluation = board_evaluate_straight_five;
            break;
        case EVALUATION_IN_ROW:
            evaluation = board_evaluate_in_row;
            break;
        case EVALUATION_IN_ROW_BLOCK:
        default:
            evaluation = board_evaluate;
            break;
    }

    clock_t begin = clock();
    switch (algorithm) {
        case NEGAMAX:
            move = negamax(board, (uint32_t) color, (uint32_t) depth, (uint32_t) turn, evaluation, move_generator);
            break;
        case NEGAMAX_AB:
        default:
            move = negamax_ab(board, (uint32_t) color, (uint32_t) depth, (uint32_t) turn, INT16_MIN, INT16_MAX, evaluation, move_generator);
            break;
    }
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    struct board* new_board = board_move(board, move);
    result = make_move_result(env, new_board, move, time_spent);

    free(new_board);
    free(move);
    free(board);
    return result;
}

static ErlNifFunc nif_funcs[] = {
        {"move", 5, move},
        {"make_move", 7, make_move},
};

ERL_NIF_INIT(Elixir.Pentago.Game.BitBoard, nif_funcs, NULL, NULL, NULL, NULL)

void tuple_to_board(ErlNifEnv *env, const ERL_NIF_TERM arg, struct board* board) {
    const ERL_NIF_TERM* tuple;
    int *temp_board = malloc(BOARD_SIZE * sizeof(int));
    int tuple_size;

    if (enif_get_tuple(env, arg, &tuple_size, &tuple) != 0) {
        for (char i = 0; i < tuple_size; ++i) {
            enif_get_int(env, *(tuple + i), (temp_board + i));
            if (*(temp_board + i) != EMPTY) {
                board_set(board, i, *(temp_board + i));
            }
        }
    }

    free(temp_board);
}

void board_to_tuple(ErlNifEnv *env, struct board* board, ERL_NIF_TERM* tuple) {
    ERL_NIF_TERM new_tuple[BOARD_SIZE];

    for (char i = 0; i < BOARD_SIZE; ++i) {
        if (board_get(board, i) == BLACK) {
            *(new_tuple + i) = enif_make_int(env, BLACK);
        } else if (board_get(board, i) == WHITE) {
            *(new_tuple + i) = enif_make_int(env, WHITE);
        } else {
            *(new_tuple + i) = enif_make_int(env, EMPTY);
        }
    }

    *tuple = enif_make_tuple_from_array(env, new_tuple, BOARD_SIZE);
}

ERL_NIF_TERM make_move_result(ErlNifEnv *env, struct board* board, struct move *move, double time) {
    ERL_NIF_TERM erl_board, erl_pos, erl_color, erl_sub_board, erl_rotation, erl_winner, erl_time, erl_leafs;
    board_to_tuple(env, board, &erl_board);
    erl_pos = enif_make_int(env, (int) move->pos);
    erl_color = enif_make_int(env, (int) move->color);
    erl_sub_board = enif_make_int(env, (int) move->sub_board);
    erl_rotation = enif_make_int(env, (int) move->rotation);
    erl_winner = enif_make_int(env, board_winner(board));
    erl_time = enif_make_double(env, time);
    erl_leafs = enif_make_long(env, nodes);

    nodes = 0;
    return enif_make_tuple(env, 8, erl_board, erl_pos, erl_color, erl_sub_board, erl_rotation, erl_winner, erl_time, erl_leafs);
}