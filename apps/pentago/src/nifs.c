#include "erl_nif.h"
#include "nifs.h"
#include "board.h"
#include "evaluation.h"
#include "algorithm.h"

static ERL_NIF_TERM make_move(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
    ERL_NIF_TERM result;
    char* board = malloc(INTERNAL_SIZE * sizeof(char));
    int algorithm,  color, depth, turn;
    tuple_to_board(env, argv[ARGV_TUPLE], board);
    enif_get_int(env, argv[1], &algorithm);
    enif_get_int(env, argv[2], &color);
    enif_get_int(env, argv[3], &depth);
    enif_get_int(env, argv[4], &turn);

    struct Move* move;
    switch (algorithm) {
        case MINIMAX:
//            move = alpha_beta(board, (char) color, (char) depth, (char) turn, -9999999, 9999999);
            move = minimax(board, (char) color, (char) depth, (char) turn);
            char* new_board = board_move(board, move);

            result = make_move_result(env, new_board, move);

            free(new_board);
            free(move);
            break;
        default:
            result = enif_make_atom(env, "error");
            break;
    }

    free(board);
    return result;
}

static ERL_NIF_TERM move(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char* board = malloc(INTERNAL_SIZE * sizeof(char));
    ERL_NIF_TERM result;
    int pos, sub_board, rotation, color;

    tuple_to_board(env, argv[ARGV_TUPLE], board);
    enif_get_int(env, argv[ARGV_POS], &pos);
    enif_get_int(env, argv[ARGV_COLOR], &color);
    enif_get_int(env, argv[ARGV_SUB_BOARD], &sub_board);
    enif_get_int(env, argv[ARGV_ROTATION], &rotation);

    struct Move *move = malloc(sizeof(struct Move));
    move->pos = (char) pos;
    move->color = (char) color;
    move->sub_board = (char) sub_board;
    move->rotation = (char) rotation;

    char* new_board = board_move(board, move);
    result = make_move_result(env, new_board, move);

    free(new_board);
    free(move);
    return result;
}

static ERL_NIF_TERM points_in_vectors(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char* board = malloc(INTERNAL_SIZE * sizeof(char));
    tuple_to_board(env, argv[ARGV_TUPLE], board);

    int points = board_points_in_vectors(board);

    ERL_NIF_TERM result = enif_make_int(env, points);

    free(board);
    return result;
}

static ERL_NIF_TERM points_in_rows(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char* board = malloc(INTERNAL_SIZE * sizeof(char));
    tuple_to_board(env, argv[ARGV_TUPLE], board);

    int points = board_points_in_rows(board);
    ERL_NIF_TERM result = enif_make_int(env, points);

    free(board);
    return result;
}

static ERL_NIF_TERM win(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char* board = malloc(INTERNAL_SIZE * sizeof(char));
    tuple_to_board(env, argv[ARGV_TUPLE], board);

    char color = board_evaluate_win(board);
    ERL_NIF_TERM result = enif_make_int(env, (int) color);

    free(board);
    return result;
}

static ErlNifFunc nif_funcs[] = {
        {"move", 5, move},
        {"points_in_rows", 1, points_in_rows},
        {"points_in_vectors", 1, points_in_vectors},
        {"win", 1, win},
        {"make_move", 5, make_move}
};

ERL_NIF_INIT(Elixir.Pentago.Game.FastBoard, nif_funcs, NULL, NULL, NULL, NULL)

void tuple_to_board(ErlNifEnv *env, const ERL_NIF_TERM arg, char* board) {
    const ERL_NIF_TERM* tuple;
    int *temp_board = malloc(INTERNAL_SIZE * sizeof(int));
    int tuple_size;

    if (enif_get_tuple(env, arg, &tuple_size, &tuple) != 0) {
        for (int i = 0; i < tuple_size; ++i) {
            enif_get_int(env, *(tuple + i), (temp_board + i));
            *(board + i) = (char) *(temp_board + i);
        }
        *(board + BOARD_SIZE) = EMPTY;
    }

    free(temp_board);
}

void board_to_tuple(ErlNifEnv *env, char* board, ERL_NIF_TERM* tuple) {
    ERL_NIF_TERM new_tuple[BOARD_SIZE];

    for (int i = 0; i < BOARD_SIZE; ++i) {
        *(new_tuple + i) = enif_make_int(env, (int) *(board + i));
    }

    *tuple = enif_make_tuple_from_array(env, new_tuple, BOARD_SIZE);
}

ERL_NIF_TERM make_move_result(ErlNifEnv *env, char* board, struct Move* move) {
    ERL_NIF_TERM erl_board, erl_pos, erl_color, erl_sub_board, erl_rotation, erl_winner, erl_leafs;
    board_to_tuple(env, board, &erl_board);
    erl_pos = enif_make_int(env, (int) move->pos);
    erl_color = enif_make_int(env, (int) move->color);
    erl_sub_board = enif_make_int(env, (int) move->sub_board);
    erl_rotation = enif_make_int(env, (int) move->rotation);
    erl_winner = enif_make_int(env, (int) board_evaluate_win(board));
    erl_leafs = enif_make_int(env, leafs);

    return enif_make_tuple(env, 7, erl_board, erl_pos, erl_color, erl_sub_board, erl_rotation, erl_winner, erl_leafs);
}
