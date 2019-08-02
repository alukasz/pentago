<template>
    <div>
        <p>Your marble <span :class="marbleClass(this.marble, -1, -1)"></span></p>
        <div id="board">
            <div v-for="(marble_row, row) in board" class="marble-row">
                <template v-for="(marble, col) in marble_row">
                    <button :id="marbleId(row, col)"
                            :class="marbleClass(marble, row, col)"
                            :disabled="marbleDisabled(marble)"
                            @click="selectMarble($event)"></button>
                </template>
            </div>

            <div v-if="playing">
                <template v-for="sub_board in SUB_BOARDS">
                    <template v-for="rotation in ROTATIONS">
                        <button :class="rotateButtonClass(sub_board, rotation)"
                                @click="makeMove(sub_board, rotation)"></button>
                    </template>
                </template>
            </div>

            <div v-if="lock">
                <div class="lock">
                    <p>{{ lock }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import socket from "../socket"
    import Consts from "../consts"

    export default {
        data() {
            return {
                SUB_BOARDS: Consts.SUB_BOARDS,
                ROTATIONS: Consts.ROTATIONS,
                channel: null,
                lock: "Loading...",
                board: [],
                marble: null,
                playing: false,
                selected: null,
            }
        },
        props: ['game_id'],
        mounted() {
            socket.connect();
            this.channel = socket.channel("game:" + this.game_id, {});
            this.channel.on("init", payload => {
                this.marble = payload.marble;
                this.lock = payload.lock;
            });
            this.channel.on("board", payload => {
                this.setBoard(payload.board)
            });
            this.channel.on("make_move", payload => {
                this.playing = true;
                this.lock = null;
            });
            this.channel.on("lock", payload => {
                this.playing = false;
                this.lock = payload.lock;
            });
            this.channel.on("result", payload => {
                this.playing = false;
                this.lock = this.winnerMessage(payload.result);
            });

            this.channel.join()
                .receive("ok", resp => {
                    console.log("Joined")
                })
                .receive("error", resp => {
                    console.log("Unable to join", resp)
                })
        },
        methods: {
            setBoard(board) {
                var temp = [], i;
                for (i = 0; i < board.length; i += 6) {
                    temp.push(board.slice(i, i + 6));
                }
                this.board = temp
            },
            selectMarble(event) {
                this.selected = event.srcElement.id;
            },
            marbleId(row, col) {
                return "marble-" + (row * Consts.ROWS + col)
            },
            marbleClass(marble, row, col) {
                if (this.selected === this.marbleId(row, col)) {
                    return "marble marble-selected"
                } else {
                    return "marble marble-" + marble
                }
            },
            marbleDisabled(marble) {
                return marble !== Consts.EMPTY;
            },
            winnerMessage(result) {
                switch (result) {
                    case "won":
                        return "You won!";
                    case "lost":
                        return "Second place";
                    case "empty":
                        return "No winner";
                    case "draw":
                        return "Draw";
                }
            },
            rotateButtonClass(sub_board, rotation) {
                return "rotate rotate-" + sub_board + "-" + rotation;
            },
            makeMove(sub_board, rotation) {
                if (this.selected === null) {
                    alert("Please select position to place marble");
                    return;
                }
                this.channel.push("make_move", {
                    position: parseInt(this.selected.split("-")[1]),
                    sub_board: sub_board,
                    rotation: rotation
                });
                this.selected = null;
                this.playing = false;
            }
        },
    }
</script>

<style>
</style>