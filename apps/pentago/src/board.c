#include "board.h"
#include "algorithm.h"

uint32_t board_get(struct board* board, char pos) {
    uint64_t mask = pos_mask[pos];
    if(board->color[BLACK] & mask) return BLACK;
    if(board->color[WHITE] & mask) return WHITE;
    return EMPTY;
}

void board_set(struct board* board, char pos, int color) {
    board->color[color] |= pos_mask[pos];
}

struct board* board_move(struct board* board, struct move* move) {
    struct board* new_board = malloc(sizeof(struct board));
    memcpy(new_board, board, sizeof(struct board));

    new_board->color[move->color] |= pos_mask[move->pos];

    if (move->rotation == 0) {
        new_board->color[BLACK] = rotate_sub_board_cw(new_board->color[BLACK], move->sub_board);
        new_board->color[WHITE] = rotate_sub_board_cw(new_board->color[WHITE], move->sub_board);
    } else {
        new_board->color[BLACK] = rotate_sub_board_ccw(new_board->color[BLACK], move->sub_board);
        new_board->color[WHITE] = rotate_sub_board_ccw(new_board->color[WHITE], move->sub_board);
    }

    return new_board;
}

int board_winner(struct board* board) {
    uint32_t winner = 0;
    uint64_t black = board->color[BLACK], white = board->color[WHITE];

    if ((black & 98311) == 98311) winner |= 1;
    if ((white & 98311) == 98311) winner |= 2;

    if ((black & 98822) == 98822) winner |= 1;
    if ((white & 98822) == 98822) winner |= 2;

    if ((black & 147848) == 147848) winner |= 1;
    if ((white & 147848) == 147848) winner |= 2;

    if ((black & 148744) == 148744) winner |= 1;
    if ((white & 148744) == 148744) winner |= 2;

    if ((black & 12400) == 12400) winner |= 1;
    if ((white & 12400) == 12400) winner |= 2;

    if ((black & 14384) == 14384) winner |= 1;
    if ((white & 14384) == 14384) winner |= 2;

    if ((black & 1639972864) == 1639972864) winner |= 1;
    if ((white & 1639972864) == 1639972864) winner |= 2;

    if ((black & 3783262208) == 3783262208) winner |= 1;
    if ((white & 3783262208) == 3783262208) winner |= 2;

    if ((black & 34730934272) == 34730934272) winner |= 1;
    if ((white & 34730934272) == 34730934272) winner |= 2;

    if ((black & 39023804416) == 39023804416) winner |= 1;
    if ((white & 39023804416) == 39023804416) winner |= 2;

    if ((black & 17315921920) == 17315921920) winner |= 1;
    if ((white & 17315921920) == 17315921920) winner |= 2;

    if ((black & 25904807936) == 25904807936) winner |= 1;
    if ((white & 25904807936) == 25904807936) winner |= 2;

    if ((black & 6291649) == 6291649) winner |= 1;
    if ((white & 6291649) == 6291649) winner |= 2;

    if ((black & 7340224) == 7340224) winner |= 1;
    if ((white & 7340224) == 7340224) winner |= 2;

    if ((black & 75497762) == 75497762) winner |= 1;
    if ((white & 75497762) == 75497762) winner |= 2;

    if ((black & 76022048) == 76022048) winner |= 1;
    if ((white & 76022048) == 76022048) winner |= 2;

    if ((black & 50331676) == 50331676) winner |= 1;
    if ((white & 50331676) == 50331676) winner |= 2;

    if ((black & 50593816) == 50593816) winner |= 1;
    if ((white & 50593816) == 50593816) winner |= 2;

    if ((black & 805363712) == 805363712) winner |= 1;
    if ((white & 805363712) == 805363712) winner |= 2;

    if ((black & 939548672) == 939548672) winner |= 1;
    if ((white & 939548672) == 939548672) winner |= 2;

    if ((black & 35433680896) == 35433680896) winner |= 1;
    if ((white & 35433680896) == 35433680896) winner |= 2;

    if ((black & 52613484544) == 52613484544) winner |= 1;
    if ((white & 52613484544) == 52613484544) winner |= 2;

    if ((black & 6442454528) == 6442454528) winner |= 1;
    if ((white & 6442454528) == 6442454528) winner |= 2;

    if ((black & 15032388608) == 15032388608) winner |= 1;
    if ((white & 15032388608) == 15032388608) winner |= 2;

    if ((black & 34896609553) == 34896609553) winner |= 1;
    if ((white & 34896609553) == 34896609553) winner |= 2;

    if ((black & 43486544144) == 43486544144) winner |= 1;
    if ((white & 43486544144) == 43486544144) winner |= 2;

    if ((black & 17465082016) == 17465082016) winner |= 1;
    if ((white & 17465082016) == 17465082016) winner |= 2;

    if ((black & 5368717322) == 5368717322) winner |= 1;
    if ((white & 5368717322) == 5368717322) winner |= 2;

    if ((black & 84025856) == 84025856) winner |= 1;
    if ((white & 84025856) == 84025856) winner |= 2;

    if ((black & 85073920) == 85073920) winner |= 1;
    if ((white & 85073920) == 85073920) winner |= 2;

    if ((black & 10567696) == 10567696) winner |= 1;
    if ((white & 10567696) == 10567696) winner |= 2;

    if ((black & 570954752) == 570954752) winner |= 1;
    if ((white & 570954752) == 570954752) winner |= 2;

    switch (winner) {
        case 1:
            return BLACK;
        case 2:
            return WHITE;
        case 3:
            return DRAW;
        default:
            return EMPTY;
    }
}

int32_t board_evaluate(struct board* board, uint32_t color) {
    int32_t points = 0;
    uint64_t b_wp, w_wp, black = board->color[BLACK], white = board->color[WHITE];

    b_wp = black & 98311;
    w_wp = white & 98311;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 98822;
    w_wp = white & 98822;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 147848;
    w_wp = white & 147848;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 148744;
    w_wp = white & 148744;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 12400;
    w_wp = white & 12400;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 14384;
    w_wp = white & 14384;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 1639972864;
    w_wp = white & 1639972864;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 3783262208;
    w_wp = white & 3783262208;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 34730934272;
    w_wp = white & 34730934272;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 39023804416;
    w_wp = white & 39023804416;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 17315921920;
    w_wp = white & 17315921920;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 25904807936;
    w_wp = white & 25904807936;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 6291649;
    w_wp = white & 6291649;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 7340224;
    w_wp = white & 7340224;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 75497762;
    w_wp = white & 75497762;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 76022048;
    w_wp = white & 76022048;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 50331676;
    w_wp = white & 50331676;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 50593816;
    w_wp = white & 50593816;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 805363712;
    w_wp = white & 805363712;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 939548672;
    w_wp = white & 939548672;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 35433680896;
    w_wp = white & 35433680896;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 52613484544;
    w_wp = white & 52613484544;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 6442454528;
    w_wp = white & 6442454528;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 15032388608;
    w_wp = white & 15032388608;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 34896609553;
    w_wp = white & 34896609553;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 43486544144;
    w_wp = white & 43486544144;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 17465082016;
    w_wp = white & 17465082016;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 5368717322;
    w_wp = white & 5368717322;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 84025856;
    w_wp = white & 84025856;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 85073920;
    w_wp = white & 85073920;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 10567696;
    w_wp = white & 10567696;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    b_wp = black & 570954752;
    w_wp = white & 570954752;
    if (w_wp == 0) points += points_value[bit_count(b_wp)];
    else if (b_wp == 0) points -= points_value[bit_count(w_wp)];

    return (color == BLACK ? points : -points);
}

inline uint64_t rotate_sub_board_cw(uint64_t b, int q) {
    uint64_t m = 0xFFull << (q*9);
    return (b & ~m) | (((b & m) >> 6) & m) | (((b & m) << 2) & m);
}

inline uint64_t rotate_sub_board_ccw(uint64_t b, int q) {
    uint64_t m = 0xFFull << (q*9);
    return (b & ~m) | (((b & m) >> 2) & m) | (((b & m) << 6) & m);
}

inline int bit_count(uint64_t n) {
    return bits_set_table[(n >> 0)  & 0xff] +
           bits_set_table[(n >> 8)  & 0xff] +
           bits_set_table[(n >> 16) & 0xff] +
           bits_set_table[(n >> 24) & 0xff] +
           bits_set_table[(n >> 32) & 0xff];
}