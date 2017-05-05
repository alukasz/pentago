#include "board.h"

#ifndef PENTAGO_ALGORITHM_H
#define PENTAGO_ALGORITHM_H

#define TURNS 35
#define MINIMAX 0

int leafs;

struct Move* minimax(char* board, char color, char rotation, char turn);
int maximize_minimax(char *board, char color, int depth, int turn, char orig_color);

struct Move* alpha_beta(char* board, char color, char rotation, char turn, int alpha, int beta);
int maximize_ab(char *board, char color, int depth, int turn, char orig_color, int alpha, int beta);

struct Move* get_available_moves(char* board, int *move_number, char color, int turn);

#endif //PENTAGO_ALGORITHM_H