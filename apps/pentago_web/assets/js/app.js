import "phoenix_html"

import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live")
liveSocket.connect()

import Vue from "vue"
import Pentago from "./components/pentago.vue"

new Vue({
  el: "#app",
  components: {
    Pentago
  }
})
