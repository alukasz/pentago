#include "erl_nif.h"
#include "board.h"
#include "algorithm.h"

#ifndef BIT_BOARD_LIBRARY_H
#define BIT_BOARD_LIBRARY_H

#define MOVE_GENERATOR_DEFAULT 0
#define MOVE_GENERATOR_SORTED 1

#define EVALUATION_IN_ROW_BLOCK 0
#define EVALUATION_IN_ROW 1

void tuple_to_board(ErlNifEnv *env, const ERL_NIF_TERM arg, struct board* board);
void board_to_tuple(ErlNifEnv *env,  struct board* board, ERL_NIF_TERM* tuple);
ERL_NIF_TERM make_move_result(ErlNifEnv *env, struct board* board, struct move *move, double time);
#endif