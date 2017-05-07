#include "board.h"

#ifndef PENTAGO_NIF_H
#define PENTAGO_NIF_H

#define ARGV_TUPLE 0
#define ARGV_POS 1
#define ARGV_COLOR 2
#define ARGV_SUB_BOARD 3
#define ARGV_ROTATION 4

void tuple_to_board(ErlNifEnv *env, const ERL_NIF_TERM arg, char* board);
void board_to_tuple(ErlNifEnv *env, char* board, ERL_NIF_TERM* tuple);
ERL_NIF_TERM make_move_result(ErlNifEnv *env, char *board, struct Move *move, double d);

#endif //PENTAGO_NIF_H
