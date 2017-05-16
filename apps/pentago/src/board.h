#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#ifndef BIT_BOARD_BOARD_H
#define BIT_BOARD_BOARD_H

#define BLACK 0
#define WHITE 1
#define EMPTY 2
#define DRAW 3

#define BOARD_SIZE 36
#define TURNS 35
#define SUB_BOARDS 4
#define ROTATIONS 2

static const uint64_t pos_mask[36] = {
        1ull <<  0, 1ull <<  1, 1ull <<  2, 1ull << 15, 1ull << 16, 1ull <<  9,
        1ull <<  7, 1ull <<  8, 1ull <<  3, 1ull << 14, 1ull << 17, 1ull << 10,
        1ull <<  6, 1ull <<  5, 1ull <<  4, 1ull << 13, 1ull << 12, 1ull << 11,
        1ull << 22, 1ull << 23, 1ull << 24, 1ull << 29, 1ull << 30, 1ull << 31,
        1ull << 21, 1ull << 26, 1ull << 25, 1ull << 28, 1ull << 35, 1ull << 32,
        1ull << 20, 1ull << 19, 1ull << 18, 1ull << 27, 1ull << 34, 1ull << 33
};

static const int points_value[6] = { 0, 1, 3, 9, 27, 127 };

struct board {
    uint64_t color[2];
};

struct move {
    uint8_t pos;
    uint8_t color : 2;
    uint8_t sub_board : 4;
    uint8_t rotation : 2;
};

struct board *board_move(struct board *board, struct move *move);
uint32_t board_get(struct board* board, char pos);
void board_set(struct board* board, char pos, int color);
int board_winner(struct board* board);
int32_t board_evaluate(struct board* board, uint32_t color);
inline uint64_t rotate_sub_board_cw(uint64_t b, int q);
inline uint64_t rotate_sub_board_ccw(uint64_t b, int q);
inline int bit_count(uint64_t n);

#endif //BIT_BOARD_BOARD_H
