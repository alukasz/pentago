#include "evaluation.h"
#include "board.h"

static char vectors[VECTORS][BOARD_ROWS] = {
        {0,  1,  2,  3,  4,  5},
        {6,  7,  8,  9,  10, 11},
        {12, 13, 14, 15, 16, 17},
        {18, 19, 20, 21, 22, 23},
        {24, 25, 26, 27, 28, 29},
        {30, 31, 32, 33, 34, 35},

        {0,  6,  12, 18, 24, 30},
        {1,  7,  13, 19, 25, 31},
        {2,  8,  14, 20, 26, 32},
        {3,  9,  15, 21, 27, 33},
        {4,  10, 16, 22, 28, 34},
        {5,  11, 17, 23, 29, 35},

        {5,  10, 15, 20, 25, 30},
        {0,  7,  14, 21, 28, 35},
        {6,  13, 20, 27, 34, 36},
        {1,  8,  15, 22, 29, 36},
        {4,  9,  14, 19, 24, 36},
        {11, 16, 21, 26, 31, 36}
};

static int points_in_vector[7][7] = {
        {IN_VECTOR_0, -IN_VECTOR_1, -IN_VECTOR_2, -IN_VECTOR_3, -IN_VECTOR_4, -IN_VECTOR_5, -IN_VECTOR_6},
        {IN_VECTOR_1, IN_VECTOR_0,  -IN_VECTOR_1, -IN_VECTOR_2, -IN_VECTOR_3, -IN_VECTOR_4, 0},
        {IN_VECTOR_2, IN_VECTOR_1, IN_VECTOR_0, IN_VECTOR_0, IN_VECTOR_0,     0,            0},
        {IN_VECTOR_3, IN_VECTOR_2, IN_VECTOR_0, IN_VECTOR_0,    0,            0,            0},
        {IN_VECTOR_4, IN_VECTOR_3, IN_VECTOR_0,   0,            0,            0,            0},
        {IN_VECTOR_5, IN_VECTOR_4,  0,            0,            0,            0,            0},
        {IN_VECTOR_6, 0,            0,            0,            0,            0,            0}
};

static int points_in_row[3][7] = {
        {IN_ROW_0, IN_ROW_1, IN_ROW_2, IN_ROW_3, IN_ROW_4, IN_ROW_5, IN_ROW_6}, // BLACK
        {IN_ROW_0, IN_ROW_1, -IN_ROW_2, -IN_ROW_3, -IN_ROW_4, -IN_ROW_5, -IN_ROW_6}, // WHITE
        {0, 0,               0,         0,         0,         0,         0} // EMPTY
};


int board_points_in_vectors(char *board) {
    int points = 0, black, white;
    char color;
    for (int i = 0; i < VECTORS; ++i) {
        black = 0;
        white = 0;
        for (int j = 0; j < BOARD_ROWS; ++j) {
            color = *(board + vectors[i][j]);
            if (color == BLACK)
                black++;
            else if (color == WHITE)
                white++;
        }
        points += points_in_vector[black][white];
    }

    return points;
}

int board_points_in_rows(char *board) {
    int points = 0, count;
    char prev, current;
    for (int i = 0; i < VECTORS; ++i) {
        prev = *(board + vectors[i][0]);
        count = 1;
        for (int j = 1; j < BOARD_ROWS; ++j) {
            current = *(board + vectors[i][j]);
            if (current == prev) {
                count++;
            } else {
                points += points_in_row[prev][count];
                prev = current;
                count = 1;
            }
        }
        points += points_in_row[prev][count];
    }

    return points;
}

char board_evaluate_win(char *board) {
    char a, b, c, d, e, f;
    for (int i = 0; i < VECTORS; ++i) {
        a = *(board + vectors[i][0]);
        b = *(board + vectors[i][1]);
        c = *(board + vectors[i][2]);
        d = *(board + vectors[i][3]);
        e = *(board + vectors[i][4]);
        f = *(board + vectors[i][5]);

        if (b != EMPTY && b == c && c == d && d == e && (a == b || e == f)) {
            return b;
        }
    }

    return EMPTY;
}