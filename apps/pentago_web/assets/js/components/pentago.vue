<template>
  <div>
  hello pentago
  </div>
</template>

<script>
  import socket from "../socket"
  const channel = socket.channel("game", {})
  const size = 36
  const rows = 6
  const black = 0
  const white = 1
  const empty = 2
  export default {
    data() {
      return {
        playing: false
      }
    },
    props: ['game_id'],
    mounted() {
    }
  }
</script>

<style>
</style>