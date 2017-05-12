#include "board.h"

#ifndef BIT_BOARD_ALGORITHM_H
#define BIT_BOARD_ALGORITHM_H

#define NEGAMAX 0
#define NEGAMAX_AB 1

uint64_t leafs;

struct move* alg_negamax(struct board* board, uint8_t color, uint8_t depth, uint8_t turn);
int16_t alg_negamax_rec(struct board* board, uint8_t color, uint8_t depth, uint8_t turn);
struct move* alg_negamax_ab(struct board* board, uint8_t color, uint8_t depth, uint8_t turn, int16_t alpha, int16_t beta);
int16_t alg_negamax_ab_rec(struct board* board, uint8_t color, uint8_t depth, uint8_t turn, int16_t alpha, int16_t beta);
struct move* get_available_moves(struct board* board, int16_t *move_number, uint8_t color, uint8_t turn);

#endif //BIT_BOARD_ALGORITHM_H
