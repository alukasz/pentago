<template>
  <div>
    <div v-if="waitingForGame">
      <p>waiting for game...</p>
    </div>
    <div v-else>
      <div v-if="is_finished">
        <div :class="winnerClass()"></div>
        <div class="current-player">won!</div>
      </div>

      <div v-else>
        <div class="current-player">Current player: {{ current_player }} </div>
        <div :class="currentColor"></div>
      </div>

      <div id="board">
        <div v-for="(marble_row, row) in board" class="marble-row">
          <template v-for="(marble, col) in marble_row">
            <button :id="marbleId(row, col)"
            :class="marbleClass(marble, row, col)"
            :disabled="marbleDisabled(marble)"
            @click="selectMarble($event)"></button>
          </template>
        </div>

        <button class="rotate rotate-0-c" @click="makeMove(0, 'clockwise')"></button>
        <button class="rotate rotate-0-cc" @click="makeMove(0, 'counter_clockwise')"></button>
        <button class="rotate rotate-1-c" @click="makeMove(1, 'clockwise')"></button>
        <button class="rotate rotate-1-cc" @click="makeMove(1, 'counter_clockwise')"></button>
        <button class="rotate rotate-2-c" @click="makeMove(2, 'clockwise')"></button>
        <button class="rotate rotate-2-cc" @click="makeMove(1, 'counter_clockwise')"></button>
        <button class="rotate rotate-3-c" @click="makeMove(3, 'clockwise')"></button>
        <button class="rotate rotate-3-cc" @click="makeMove(1, 'counter_clockwise')"></button>
      </div>

      <template v-for="move in moves">
        <div>
          <div :class="moveClass(move)"></div>
          <div class="current-player">
            {{ row(move) }}-{{ col(move)}}, {{ move.sub_board }} {{ rotation(move) }}
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
  import socket from "../socket"
  const channel = socket.channel("game", {})
  const size = 36
  const rows = 6

  export default {
    data() {
      return {
        playing: false,
        is_finished: false,
        current_player: this.player1,
        current_color: "black",
        winner: "empty",
        board: [],
        moves: [],
        turn: 0,
        selected_marble: ""
      }
    },
    props: ['player1', 'player2'],
    mounted() { 2
      socket.connect()

      channel.on("initial_board", payload => {
        this.selected_marble = ""
        this.current_color = payload.color
        this.current_player = payload.player
        this.setBoard(payload.board)
        this.playing = true
        this.checkEndingConditions()
        this.makeAIMove()
      })

      channel.on("new_board", payload => {
        console.log(payload)
        this.selected_marble = ""
        this.current_color = payload.color
        this.current_player = payload.player
        this.setBoard(payload.board)
        this.moves.unshift(payload.move)
        this.winner = payload.winner
        this.checkEndingConditions()
        this.makeAIMove()
      })

      channel.join()
        .receive("ok", resp => {
          console.log("joined")
          this.startGame()
        })
        .receive("error", resp => {
          console.log("Unable to join", resp)
        })
    },
    computed: {
      currentColor() {
        return "marble marble-" + this.current_color
      },
      waitingForGame() {
        return !this.playing
      }
    },
    methods: {
      setBoard(board) {
        var temp = [], i;
        for (i = 0; i < board.length; i += 6) {
            temp.push(board.slice(i, i + 6));
        }
        this.board = temp
      },
      startGame() {
        channel.push("start_game", {
          player1: this.player1,
          player2: this.player2
        })
      },
      makeMove(sub_board, rotation) {
        if (this.selected_marble == "") {
          return alert("choose where to put marble")
        }
        channel.push("make_move", {
          player: this.current_player,
          pos: this.selected_marble.split("-")[1],
          color: this.current_color,
          sub_board: sub_board,
          rotation: rotation
        })
      },
      makeAIMove() {
        if (this.current_player != "human" && (!this.is_finished)) {
          channel.push("make_move", {
            player: this.current_player,
            color: this.current_color
          })
        }
      },
      checkEndingConditions() {
        if (this.winner == "black" || this.winner == "white" || this.turn == 35) {
          this.is_finished = true
        }
      },
      selectMarble(event) {
        this.selected_marble = event.srcElement.id
      },
      marbleId(row, col) {
        return "marble-" + (row * rows + col)
      },
      marbleClass(marble, row, col) {
        if (this.selected_marble == this.marbleId(row, col)) {
          return "marble marble-selected"
        } else {
          return "marble marble-" + marble
        } 
      },
      winnerClass() {
        return "marble marble-" + this.winner
      },
      marbleDisabled(marble) {
        return marble != "empty" ||
          this.current_player != "human" ||
          this.is_finished
      },
      row(move) {
        return Math.floor(move.pos / rows) + 1
      },
      col(move) {
        return move.pos % rows + 1
      },
      rotation(move) {
        if (move.rotation == 0) {
          return "clockwise"
        }
        return "counter clocwise"
      },
      moveClass(move) {
        if (move.color == 0) {
          return "marble marble-black"
        }
        return "marble marble-white"
      }
    }
  }
</script>

<style>
  #board {
    position: relative;
    width: 380px;
    margin: 50px auto;
  }
  .current-player {
    display: inline-block;
    vertical-align: middle;
    height: 65px;
    margin-right: 10px;
    font-size: 20px;
  }

  .marble-row:nth-child(3) {
    margin-bottom: 20px;
  }

  .marble {
    display: inline-block;
    width: 50px;
    height: 50px;
    background-color: white;
    background-size: contain;
    margin: 5px;
    border: none;
    cursor: default;
  }

  .marble:nth-child(3) {
    margin-right: 20px;
  }

  .marble-black {
    background-image: url(/images/marble-black.png);
  }

  .marble-white {
    background-image: url(/images/marble-white.png);
  }

  .marble-empty {
    background-image: url(/images/marble-empty.png);
  }

  .marble-empty:hover {
    background-image: url(/images/marble-hover.png);
    cursor: pointer;
  }

  .marble-selected {
    background-image: url(/images/marble-selected.png);
  }

  .rotate {
    position: absolute;
    width: 40px;
    height: 40px;
    background-color: white;
    background-size: contain;
    border: none;
  }
  .rotate-0-c {
    background-image: url(/images/rotate-0-c.png);
    top: -50px;
    left: 20px;
  }

  .rotate-0-cc {
    background-image: url(/images/rotate-0-cc.png);
    top: 20px;
    left: -50px;
  }

  .rotate-1-c {
    background-image: url(/images/rotate-1-c.png);
    top: 20px;
    right: -50px;
  }
  .rotate-1-cc {
    background-image: url(/images/rotate-1-cc.png);
    top: -50px;
    right: 20px;
  }

  .rotate-2-c {
    background-image: url(/images/rotate-2-c.png);
    bottom: 20px;
    left: -50px;
  }
  .rotate-2-cc {
    background-image: url(/images/rotate-2-cc.png);
    bottom: -50px;
    left: 20px;
  }

  .rotate-3-c {
    background-image: url(/images/rotate-3-c.png);
    bottom: -50px;
    right: 20px;
  }
  .rotate-3-cc {
    background-image: url(/images/rotate-3-cc.png);
    bottom: 20px;
    right: -50px;
  }
</style>
