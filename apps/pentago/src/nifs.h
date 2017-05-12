#include "erl_nif.h"
#include "board.h"
#include "algorithm.h"

#ifndef BIT_BOARD_LIBRARY_H
#define BIT_BOARD_LIBRARY_H

#define ARGV_TUPLE 0
#define ARGV_POS 1
#define ARGV_COLOR 2
#define ARGV_SUB_BOARD 3
#define ARGV_ROTATION 4

void tuple_to_board(ErlNifEnv *env, const ERL_NIF_TERM arg, struct board* board);
void board_to_tuple(ErlNifEnv *env,  struct board* board, ERL_NIF_TERM* tuple);
ERL_NIF_TERM make_move_result(ErlNifEnv *env, struct board* board, struct move *move, double time);
#endif