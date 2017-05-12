#include "algorithm.h"

struct move* alg_negamax(struct board* board, uint8_t color, uint8_t depth, uint8_t turn) {
    int16_t move_number, value, best_value = -10000;
    struct move* moves = get_available_moves(board, &move_number, color, turn);
    struct move* best_move = malloc(sizeof(struct move));

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -alg_negamax_rec(new_board, (uint8_t)1 - color, depth - (uint8_t)1, turn + (uint8_t)1);
        free(new_board);
        if (value > best_value) {
            *best_move = *(moves + i);
            best_value = value;
        }
    }

    free(moves);
    return best_move;
}

int16_t alg_negamax_rec(struct board* board, uint8_t color, uint8_t depth, uint8_t turn) {
    if (depth == 0 || board_winner(board) != EMPTY) {
        ++leafs;
        return board_evaluate(board, color);
    }
    int16_t move_number, value, best_value = -10000;
    struct move* moves = get_available_moves(board, &move_number, color, turn);

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -alg_negamax_rec(new_board, (uint8_t)1 - color, depth - (uint8_t)1, turn + (uint8_t)1);
        free(new_board);
        if (value > best_value) best_value = value;
    }

    free(moves);
    return best_value;
}

struct move* alg_negamax_ab(struct board* board, uint8_t color, uint8_t depth, uint8_t turn, int16_t alpha, int16_t beta) {
    int16_t move_number, value, best_value = -10000;
    struct move* moves = get_available_moves(board, &move_number, color, turn);
    struct move* best_move = malloc(sizeof(struct move));

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -alg_negamax_ab_rec(new_board, (uint8_t)1 - color, depth - (uint8_t)1, turn + (uint8_t)1, -beta, -alpha);
        free(new_board);
        if (value > best_value) {
            *best_move = *(moves + i);
            best_value = value;
        }
        if (best_value > alpha) alpha = best_value;
        if (alpha >= beta) {
            free(moves);
            return best_move;
        }
    }

    free(moves);
    return best_move;
}

int16_t alg_negamax_ab_rec(struct board* board, uint8_t color, uint8_t depth, uint8_t turn, int16_t alpha, int16_t beta) {
    if (depth == 0 || board_winner(board) != EMPTY) {
        ++leafs;
        return board_evaluate(board, color);
    }
    int16_t move_number, value, best_value = -10000;
    struct move* moves = get_available_moves(board, &move_number, color, turn);

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -alg_negamax_ab_rec(new_board, (uint8_t)1 - color, depth - (uint8_t)1, turn + (uint8_t)1, -beta, -alpha);
        free(new_board);
        if (value > best_value) best_value = value;
        if (best_value > alpha) alpha = best_value;
        if (alpha >= beta) {
            free(moves);
            return best_value;
        }
    }

    free(moves);
    return best_value;
}

struct move* get_available_moves(struct board* board, int16_t *move_number, uint8_t color, uint8_t turn) {
    uint64_t colors = board->color[BLACK] | board->color[WHITE];
    struct move* moves = malloc((TURNS + 1 - turn) * 8 * sizeof(struct move));
    *move_number = 0;

    uint64_t mask;
    for (uint8_t i = 0; i < BOARD_SIZE; ++i) {
        mask = pos_mask[i];
        if((colors & mask) == 0) {
            for (uint8_t sub_board = 0; sub_board < SUB_BOARDS; ++sub_board) {
                for (uint8_t rotation = 0; rotation < ROTATIONS; ++rotation) {
                    (moves + *move_number)->pos = i;
                    (moves + *move_number)->color = color;
                    (moves + *move_number)->sub_board = sub_board;
                    (moves + *move_number)->rotation = rotation;
                    ++(*move_number);
                }
            }
        };
    }

    return moves;
}

