import "phoenix_html"

import Vue from "vue"
import socket from "./game"
import Pentago from "./components/pentago.vue"

new Vue({
  el: "#app",
  components: {
    Pentago
  }
})
