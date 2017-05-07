#ifndef PENTAGO_EVALUATION_H
#define PENTAGO_EVALUATION_H

#define VECTORS 18

#define IN_VECTOR_0 0
#define IN_VECTOR_1 0
#define IN_VECTOR_2 1
#define IN_VECTOR_3 5
#define IN_VECTOR_4 50
#define IN_VECTOR_5 500
#define IN_VECTOR_6 1000

#define IN_ROW_0 0
#define IN_ROW_1 0
#define IN_ROW_2 1
#define IN_ROW_3 100
#define IN_ROW_4 1000
#define IN_ROW_5 100000
#define IN_ROW_6 100000

char board_evaluate_win(char* board);
int board_points_in_vectors(char *board);
int board_points_in_rows(char *board);

#endif //PENTAGO_EVALUATION_H
