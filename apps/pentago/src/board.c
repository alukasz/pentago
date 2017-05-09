#include "board.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char sub_boards[SUB_BOARDS][SUB_BOARD_SIZE] = {
        {0,  1,  2,  6,  8,  12, 13, 14},
        {3,  4,  5,  9,  11, 15, 16, 17},
        {18, 19, 20, 24, 26, 30, 31, 32},
        {21, 22, 23, 27, 29, 33, 34, 35}
};

static char transformation[2][SUB_BOARD_SIZE] = {
        {2,  7, 12, -5, 5,  -12, -7, -2}, // clockwise
        {12, 5, -2, 7,  -7, 2,   -5, -12} // counter clockwise
};

char* board_move(char *board, struct Move* move) {
    // create new board from old
    char *new_board = malloc(INTERNAL_SIZE * sizeof(char));
    memcpy(new_board, board, INTERNAL_SIZE * sizeof(char));
    // update color
    *(new_board + move->pos) = move->color;
    char orig_color = *(board + move->pos);
    *(board + move->pos) = move->color;
    // rotate
    char pos;
    for (int i = 0; i < SUB_BOARD_SIZE; ++i) {
        pos = sub_boards[move->sub_board][i];
        *(new_board + pos + transformation[move->rotation][i]) = *(board + pos);
    }

    // restore color on original board
    *(board + move->pos) = orig_color;
    return new_board;
}


