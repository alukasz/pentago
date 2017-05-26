#include "board.h"

#ifndef BIT_BOARD_ALGORITHM_H
#define BIT_BOARD_ALGORITHM_H

#define NEGAMAX 0
#define NEGAMAX_AB 1

uint64_t nodes;


// board, color
typedef int32_t (*evaluation)(struct board*, uint32_t);

// board, move_numbers, color, turn
typedef struct move* (*move_generator)(struct board*, size_t*, uint32_t, uint32_t, evaluation);

struct move* negamax(struct board* board,
                     uint32_t color,
                     uint32_t depth,
                     uint32_t turn,
                     evaluation evaluation,
                     move_generator move_generator
);
int32_t negamax_rec(struct board* board,
                     uint32_t color,
                     uint32_t depth,
                     uint32_t turn,
                     evaluation evaluation,
                     move_generator move_generator
);

struct move* negamax_ab(struct board* board,
                     uint32_t color,
                     uint32_t depth,
                     uint32_t turn,
                     int32_t alpha,
                     int32_t beta,
                     evaluation evaluation,
                     move_generator move_generator
);
int32_t negamax_ab_rec(struct board* board,
                    uint32_t color,
                    uint32_t depth,
                    uint32_t turn,
                     int32_t alpha,
                     int32_t beta,
                    evaluation evaluation,
                    move_generator move_generator
);

struct move* get_available_moves(struct board* board, size_t *move_number, uint32_t color, uint32_t turn, evaluation evaluation);
struct move* get_available_moves_sorted(struct board* board, size_t *move_number, uint32_t color, uint32_t turn, evaluation evaluation);
int sort_moves(const void *elem1, const void *elem2);

#endif //BIT_BOARD_ALGORITHM_H
