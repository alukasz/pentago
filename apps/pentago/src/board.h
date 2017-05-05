#ifndef PENTAGO_LIBRARY_H
#define PENTAGO_LIBRARY_H

#include <wchar.h>

#define INTERNAL_SIZE 37 // last item is a 6th element for 5-elements diagonals,
                         // setting it to EMPTY doesn't change output of the evaluation
#define BOARD_SIZE 36
#define BOARD_ROWS 6
#define BLACK 0
#define WHITE 1
#define EMPTY 2

#define SUB_BOARDS 4
#define SUB_BOARD_SIZE 8
#define ROTATIONS 2
#define CLOCKWISE 0
#define COUNTER_CLOCKWISE 1

struct Move {
    char pos;
    char color;
    char sub_board;
    char rotation;
};

char* board_move(char* board, struct Move *move);
char opposite_color(char color);

#endif