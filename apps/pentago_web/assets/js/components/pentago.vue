<template>
  <div>
    <div v-for="(marble_row, row) in board" class="marble-row">
      <template v-for="(marble, col) in marble_row">
        <button :id="marbleId(row, col)"
        :class="marbleClass(marble, row, col)"
        :disabled="marbleDisabled(marble)"
        @click="selectMarble($event)"></button>
      </template>
    </div>

    <button class="btn btn-primary" @click="makeMove(0, 'clockwise')">1 clockwise</button>
    <button class="btn btn-primary" @click="makeMove(0, 'counter_clockwise')">1 counter-clockwise</button><br>
    <button class="btn btn-primary" @click="makeMove(1, 'clockwise')">2 clockwise</button>
    <button class="btn btn-primary" @click="makeMove(1, 'counter_clockwise')">2 counter-clockwise</button><br>
    <button class="btn btn-primary" @click="makeMove(2, 'clockwise')">3 clockwise</button>
    <button class="btn btn-primary" @click="makeMove(2, 'counter_clockwise')">3 counter-clockwise</button><br>
    <button class="btn btn-primary" @click="makeMove(3, 'clockwise')">4 clockwise</button>
    <button class="btn btn-primary" @click="makeMove(3, 'counter_clockwise')">4 counter-clockwise</button>
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
        board: [],
        selected_marble: "",
        color: "black"
      }
    },
    mounted() {
      this.initialBoard()
      socket.connect()

      channel.on("new_board", payload => {
        this.selected_marble = ""
        this.setBoard(payload.board)
      })

      channel.join()
        .receive("ok", resp => {
          console.log("joined")
        })
        .receive("error", resp => {
          console.log("Unable to join", resp)
        })
    },
    computed: {

    },
    methods: {
      initialBoard() {
        var temp = []
        for (var i = 0; i < size; i++) {
          temp.push("empty")
        }
        this.setBoard(temp)
      },
      setBoard(board) {
        var temp = [], i;
        for (i = 0; i < board.length; i += 6) {
            temp.push(board.slice(i, i + 6));
        }
        this.board = temp
      },
      makeMove(sub_board, rotation) {
        channel.push("make_move", {
          pos: this.selected_marble.split("-")[1],
          color: this.color,
          sub_board: sub_board,
          rotation: rotation
        })

        if (this.color == "black") {
          this.color = "white"
        } else {
          this.color = "black"
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
      marbleDisabled(marble) {
        return marble != "empty"
      }
    }
  }
</script>

<style>
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
</style>
