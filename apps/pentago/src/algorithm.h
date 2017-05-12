#include "board.h"

#ifndef BIT_BOARD_ALGORITHM_H
#define BIT_BOARD_ALGORITHM_H

#define NEGAMAX 0
#define NEGAMAX_AB 1

uint64_t nodes;

struct move* alg_negamax(struct board* board, uint32_t color, uint32_t depth, uint32_t turn);
int32_t alg_negamax_rec(struct board* board, uint32_t color, uint32_t depth, uint32_t turn);
struct move* alg_negamax_ab(struct board* board, uint32_t color, uint32_t depth, uint32_t turn, int32_t alpha, int32_t beta);
int32_t alg_negamax_ab_rec(struct board* board, uint32_t color, uint32_t depth, uint32_t turn, int32_t alpha, int32_t beta);
struct move* get_available_moves(struct board* board, int32_t *move_number, uint32_t color, uint32_t turn);

#endif //BIT_BOARD_ALGORITHM_H
