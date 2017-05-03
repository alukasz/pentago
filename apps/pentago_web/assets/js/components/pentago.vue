<template>
  <div>
    <span v-for="row in board">
      <span v-for="marble in row">
        {{ marble }}
      </span>
      <br>
    </span>
    <button @click="makeMove">Random move</button>
  </div>
</template>

<script>
  import socket from "../socket"
  const channel = socket.channel("game", {})

  export default {
    data() {
      return {
        board: [],
        color: "black"
      }
    },
    mounted() {
      socket.connect()

      channel.on("new_board", payload => {
        console.log(payload.board)
        this.prepareBoard(payload.board)
      })

      channel.join()
        .receive("ok", resp => {
          console.log("joined")
        })
        .receive("error", resp => {
          console.log("Unable to join", resp)
        })
    },
    methods: {
      prepareBoard(board) {
        var temp = [], i;
        for (i = 0; i < board.length; i += 6) {
            temp.push(board.slice(i, i + 6));
        }
        this.board = temp
      },
      makeMove() {
        channel.push("make_move", {
          pos: 0,
          color: this.color,
          sub_board: 0,
          rotation: "clockwise"
        })

        if (this.color == "black") {
          this.color = "white"
        } else {
          this.color = "black"
        }
      }
    }
  }
</script>

<style>
</style>
