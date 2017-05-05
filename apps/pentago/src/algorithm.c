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
        int points = board_points_in_vectors(board) + board_points_in_rows(board);
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


struct Move* alpha_beta(char *board, char color, char depth, char turn, int alpha, int beta) {
    int current_points, moves_number, points = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    struct Move* best_move = malloc(sizeof(struct Move));
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        current_points = maximize_ab(new_board, opposite_color(color), depth - 1, turn + 1, color, -beta, -alpha);
        if (current_points > points) {
            points = current_points;
            *best_move = *(moves + i);
        }
        if (current_points > alpha) {
            alpha = current_points;
        }
        free(new_board);
        if (alpha >= beta) {
            break;
        }
    }

    free(moves);

    return best_move;
}

int maximize_ab(char *board, char color, int depth, int turn, char orig_color, int alpha, int beta) {
    if (depth == 0 || turn == TURNS || board_evaluate_win(board) != EMPTY) {
        leafs++;
        int points = board_points_in_vectors(board) + board_points_in_rows(board);
        if (orig_color == BLACK)
            return points;
        else
            return -points;
    }

    int current_points, moves_number, points = -9999999;
    struct Move* moves = get_available_moves(board, &moves_number, color, turn);
    for (int i = 0; i < moves_number; ++i) {
        char * new_board = board_move(board, (moves + i));
        current_points = maximize_ab(new_board, opposite_color(color), depth - 1, turn + 1, orig_color, -beta, -alpha);
        if (current_points > points) {
            points = current_points;
        }
        if (current_points > alpha) {
            alpha = current_points;
        }
        free(new_board);
        if (alpha >= beta) {
            break;
        }
    }

    free(moves);
    return points;
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