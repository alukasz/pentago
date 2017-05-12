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
#define WIN_PATTERNS 32
#define SUB_BOARDS 4
#define ROTATIONS 2

#define BIT_COUNT(x) __builtin_popcountll(x)
#define WIN_PATTERN(a,b,c,d,e) ((1ull<<(a)) | (1ull<<(b)) | (1ull<<(c)) | (1ull<<(d)) | (1ull<<(e)))

const uint64_t pos_mask[36];

const uint64_t win_patterns[32];

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
uint8_t board_get(struct board* board, char pos);
void board_set(struct board* board, char pos, int color);
int board_winner(struct board* board);
int16_t board_evaluate(struct board* board, uint8_t color);
static uint64_t rotate_sub_board_cw(uint64_t b, int q);
static uint64_t rotate_sub_board_ccw(uint64_t b, int q);

#endif //BIT_BOARD_BOARD_H
