#include <stdio.h>
#include "algorithm.h"

struct move* negamax(struct board *board,
                     uint32_t color,
                     uint32_t depth,
                     uint32_t turn,
                     evaluation evaluation,
                     move_generator move_generator
) {
    int32_t value, best_value = -INT16_MIN;
    size_t move_number;
    struct move* moves = move_generator(board, &move_number, color, turn, evaluation);
    struct move* best_move = malloc(sizeof(struct move));
    *best_move = *moves;

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -negamax_rec(new_board, (uint32_t)1 - color, depth - (uint32_t)1, turn + (uint32_t)1, evaluation, move_generator);
        free(new_board);
        if (value > best_value) {
            *best_move = *(moves + i);
            best_value = value;
        }
    }

    free(moves);
    return best_move;
}

int32_t negamax_rec(struct board *board,
                    uint32_t color,
                    uint32_t depth,
                    uint32_t turn,
                    evaluation evaluation,
                    move_generator move_generator
) {
    ++nodes;
    if (depth == 0 || board_winner(board) != EMPTY) {
        return evaluation(board, color);
    }
    int32_t value, best_value = INT16_MIN;
    size_t move_number;
    struct move* moves;
    if (depth > 1) {
        moves = move_generator(board, &move_number, color, turn, evaluation);
    } else {
        moves = get_available_moves(board, &move_number, color, turn, evaluation);
    }
    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -negamax_rec(new_board, (uint32_t)1 - color, depth - (uint32_t)1, turn + (uint32_t)1, evaluation, move_generator);
        free(new_board);
        if (value > best_value) best_value = value;
    }

    free(moves);
    return best_value;
}
struct move* negamax_ab(struct board *board,
                     uint32_t color,
                     uint32_t depth,
                     uint32_t turn,
                     int32_t alpha,
                     int32_t beta,
                     evaluation evaluation,
                     move_generator move_generator
) {
    int32_t value, best_value = INT16_MIN;
    size_t move_number;
    struct move* moves = move_generator(board, &move_number, color, turn, evaluation);
    struct move* best_move = malloc(sizeof(struct move));
    *best_move = *moves;

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -negamax_ab_rec(new_board, (uint32_t)1 - color, depth - (uint32_t)1, turn + (uint32_t)1, -beta, -alpha, evaluation, move_generator);
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

int32_t negamax_ab_rec(struct board *board,
                        uint32_t color,
                        uint32_t depth,
                        uint32_t turn,
                        int32_t alpha,
                        int32_t beta,
                        evaluation evaluation,
                        move_generator move_generator
) {
    ++nodes;
    if (depth == 0 || board_winner(board) != EMPTY) {
        return evaluation(board, color);
    }
    int32_t value, best_value = INT16_MIN;
    size_t move_number;
    struct move* moves;
    if (depth > 1) {
        moves = move_generator(board, &move_number, color, turn, evaluation);
    } else {
        moves = get_available_moves(board, &move_number, color, turn, evaluation);
    }

    for (int i = 0; i < move_number; ++i) {
        struct board* new_board = board_move(board, (moves + i));
        value = -negamax_ab_rec(new_board, (uint32_t)1 - color, depth - (uint32_t)1, turn + (uint32_t)1, -beta, -alpha, evaluation, move_generator);
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

struct move *get_available_moves(struct board *board, size_t *move_number, uint32_t color, uint32_t turn, evaluation evaluation) {
    uint64_t colors = board->color[BLACK] | board->color[WHITE];
    struct move *moves = calloc((TURNS + 2 - turn) * 8, sizeof(struct move));
    *move_number = 0;

    uint64_t mask, colors_with_mask, rot_mask[4] = {0x1FFull, 0x1FFull << 9, 0x1FFull << 18, 0x1FFull << 27};
    for (uint8_t i = 0; i < BOARD_SIZE; ++i) {
        mask = pos_mask[i];
        if ((colors & mask) == 0) {
            colors_with_mask = colors | mask;
            for (uint8_t sub_board = 0; sub_board < SUB_BOARDS; ++sub_board) {
                if ((colors_with_mask & rot_mask[sub_board]) != 0) {
                    for (uint8_t rotation = 0; rotation < ROTATIONS; ++rotation) {
                        (moves + *move_number)->pos = i;
                        (moves + *move_number)->color = (uint8_t) color;
                        (moves + *move_number)->sub_board = sub_board;
                        (moves + *move_number)->rotation = rotation;
                        ++(*move_number);
                    }
                }
            }
        }
    }

    return moves;
}

struct move *get_available_moves_sorted(struct board *board, size_t *move_number, uint32_t color, uint32_t turn, evaluation evaluation) {
    struct move *moves = get_available_moves(board, move_number, color, turn, evaluation);

    for (int i = 0; i < *move_number; ++i) {
        struct board *new_board = board_move(board, (moves + i));
        (moves + i)->points = evaluation(new_board, color);
        free(new_board);
    }

    qsort(moves, *move_number, sizeof(struct move), &sort_moves);

    return moves;
}

int sort_moves(const void *elem1, const void *elem2) {
    return ((struct move *) elem2)->points - ((struct move *) elem1)->points;
}