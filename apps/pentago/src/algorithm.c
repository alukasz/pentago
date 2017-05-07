#include <malloc.h>
#include "algorithm.h"
#include "board.h"
#include "evaluation.h"

struct Move* minimax(char *board, char color, char depth, char turn) {
    int current_points, moves_number, points = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    struct Move* best_move = malloc(sizeof(struct Move));
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        current_points = maximize_minimax(new_board, opposite_color(color), depth - 1, turn + 1, color);
        if (current_points > points) {
            points = current_points;
            *best_move = *(moves + i);
        }
        free(new_board);
    }

    free(moves);

    return best_move;
}

int maximize_minimax(char *board, char color, int depth, int turn, char orig_color) {
    if (depth == 0 || turn == TURNS || board_evaluate_win(board) != EMPTY) {
        leafs++;
        int points = board_points_in_rows(board) + board_points_in_vectors(board);
        if (orig_color == BLACK)
            return points;
        else
            return 0;
    }

    int current_points, moves_number, points = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        current_points = maximize_minimax(new_board, opposite_color(color), depth - 1, turn + 1, orig_color);
        if (current_points > points) {
            points = current_points;
        }
        free(new_board);
    }

    free(moves);

    return points;
}


struct Move* alphabeta(char *board, char color, char depth, char turn, int alpha, int beta) {
    int value, moves_number, best_value = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    struct Move* best_move = malloc(sizeof(struct Move));
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        value = maximize_alphabeta(new_board, opposite_color(color), depth - 1,
                                            turn + 1, color, -beta, -alpha);
        if (value > best_value) {
            best_value = value;
            *best_move = *(moves + i);
        }
        if (best_value > alpha) {
            alpha = best_value;
        }
        free(new_board);
        if (alpha >= beta) {
            free(moves);
            return best_move;
        }
    }

    free(moves);
    return best_move;
}

int maximize_alphabeta(char *board, char color, int depth, int turn, char orig_color, int alpha, int beta) {
    if (depth == 0 || turn == TURNS || board_evaluate_win(board) != EMPTY) {
        leafs++;
        int points = board_points_in_rows(board) + board_points_in_vectors(board);
        if (orig_color == BLACK)
            return points;
        else
            return -points;
    }

    int value, moves_number, best_value = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        value = maximize_alphabeta(new_board,opposite_color(color), depth - 1,
                                            turn + 1, orig_color, -beta, -alpha);
        if (value > best_value) {
            best_value = value;
        }
        if (value > alpha) {
            alpha = value;
        }
        free(new_board);
        if (alpha >= beta) {
            free(moves);
            return best_value;
        }
    }

    free(moves);
    return best_value;
}

struct Move* get_available_moves(char* board, int *move_number, char color, int turn) {
    struct Move* moves = malloc((TURNS + 1 - turn) * 8 * sizeof(struct Move));
    *move_number = 0;
    for (int i = 0; i < BOARD_SIZE; ++i) {
        if (*(board + i) == EMPTY) {
            for (char sub_board = 0; sub_board < SUB_BOARDS; ++sub_board) {
                for (char rotation = 0; rotation < ROTATIONS; ++rotation) {
                    (moves + *move_number)->pos = (char) i;
                    (moves + *move_number)->color = color;
                    (moves + *move_number)->sub_board = sub_board;
                    (moves + *move_number)->rotation = rotation;
                    (*move_number)++;
                }
            }
        }
    }

    return moves;
}