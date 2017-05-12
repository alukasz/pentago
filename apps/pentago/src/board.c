#include "board.h"
#include "algorithm.h"

const uint64_t pos_mask[36] = {
        1ull <<  0, 1ull <<  1, 1ull <<  2, 1ull << 15, 1ull << 16, 1ull <<  9,
        1ull <<  7, 1ull <<  8, 1ull <<  3, 1ull << 14, 1ull << 17, 1ull << 10,
        1ull <<  6, 1ull <<  5, 1ull <<  4, 1ull << 13, 1ull << 12, 1ull << 11,
        1ull << 22, 1ull << 23, 1ull << 24, 1ull << 29, 1ull << 30, 1ull << 31,
        1ull << 21, 1ull << 26, 1ull << 25, 1ull << 28, 1ull << 35, 1ull << 32,
        1ull << 20, 1ull << 19, 1ull << 18, 1ull << 27, 1ull << 34, 1ull << 33
};

const uint64_t win_patterns[32] = {
//horizontal
        WIN_PATTERN( 0,  1,  2, 15, 16), WIN_PATTERN( 1,  2, 15, 16,  9),
        WIN_PATTERN( 7,  8,  3, 14, 17), WIN_PATTERN( 8,  3, 14, 17, 10),
        WIN_PATTERN( 6,  5,  4, 13, 12), WIN_PATTERN( 5,  4, 13, 12, 11),
        WIN_PATTERN(22, 23, 24, 29, 30), WIN_PATTERN(23, 24, 29, 30, 31),
        WIN_PATTERN(21, 26, 25, 28, 35), WIN_PATTERN(26, 25, 28, 35, 32),
        WIN_PATTERN(20, 19, 18, 27, 34), WIN_PATTERN(19, 18, 27, 34, 33),
//vertical
        WIN_PATTERN( 0,  7,  6, 22, 21), WIN_PATTERN( 7,  6, 22, 21, 20),
        WIN_PATTERN( 1,  8,  5, 23, 26), WIN_PATTERN( 8,  5, 23, 26, 19),
        WIN_PATTERN( 2,  3,  4, 24, 25), WIN_PATTERN( 3,  4, 24, 25, 18),
        WIN_PATTERN(15, 14, 13, 29, 28), WIN_PATTERN(14, 13, 29, 28, 27),
        WIN_PATTERN(16, 17, 12, 30, 35), WIN_PATTERN(17, 12, 30, 35, 34),
        WIN_PATTERN( 9, 10, 11, 31, 32), WIN_PATTERN(10, 11, 31, 32, 33),
//diagonal
        WIN_PATTERN( 0,  8,  4, 29, 35), WIN_PATTERN( 8,  4, 29, 35, 33),
        WIN_PATTERN( 7,  5, 24, 28, 34), WIN_PATTERN( 1,  3, 13, 30, 32),
        WIN_PATTERN( 9, 17, 13, 24, 26), WIN_PATTERN(17, 13, 24, 26, 20),
        WIN_PATTERN(16, 14,  4, 23, 21), WIN_PATTERN(10, 12, 29, 25, 19),
};

uint8_t board_get(struct board* board, char pos) {
    uint64_t mask = pos_mask[pos];
    if(board->color[BLACK] & mask) return BLACK;
    if(board->color[WHITE] & mask) return WHITE;
    return EMPTY;
}

void board_set(struct board* board, char pos, int color) {
    board->color[color] |= pos_mask[pos];
}

struct board* board_move(struct board* board, struct move* move) {
    struct board* new_board = malloc(sizeof(struct board));
    memcpy(new_board, board, sizeof(struct board));

    new_board->color[move->color] |= pos_mask[move->pos];

    if (move->rotation == 0) {
        new_board->color[BLACK] = rotate_sub_board_cw(new_board->color[BLACK], move->sub_board);
        new_board->color[WHITE] = rotate_sub_board_cw(new_board->color[WHITE], move->sub_board);
    } else {
        new_board->color[BLACK] = rotate_sub_board_ccw(new_board->color[BLACK], move->sub_board);
        new_board->color[WHITE] = rotate_sub_board_ccw(new_board->color[WHITE], move->sub_board);
    }

    return new_board;
}

int board_winner(struct board* board) {
    uint8_t winner = 0;

    for (int i = 0; i < WIN_PATTERNS; ++i) {
        uint64_t wp = win_patterns[i];
        if ((board->color[BLACK] & wp) == wp) winner |= 1;
        if ((board->color[WHITE] & wp) == wp) winner |= 2;
    }

    switch (winner) {
        case 1:
            return BLACK;
        case 2:
            return WHITE;
        case 3:
            return DRAW;
        default:
            return EMPTY;
    }
}

const int points_value[6] = { 0, 1, 3, 9, 27, 127 };

int16_t board_evaluate(struct board* board, uint8_t color) {
    int16_t points = 0;

    for (int i = 0; i < WIN_PATTERNS; ++i) {
        uint64_t wp = win_patterns[i];
        uint64_t b_wp = board->color[BLACK] & wp;
        uint64_t w_wp = board->color[WHITE] & wp;
        if (w_wp == 0) points += points_value[BIT_COUNT(b_wp)];
        else if (b_wp == 0) points -= points_value[BIT_COUNT(w_wp)];
    }

    return (color == BLACK ? points : -points);
}

static uint64_t rotate_sub_board_cw(uint64_t b, int q) {
    uint64_t m = 0xFFull << (q*9);
    return (b & ~m) | (((b & m) >> 6) & m) | (((b & m) << 2) & m);
}

static uint64_t rotate_sub_board_ccw(uint64_t b, int q) {
    uint64_t m = 0xFFull << (q*9);
    return (b & ~m) | (((b & m) >> 2) & m) | (((b & m) << 6) & m);
}
