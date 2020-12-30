const { Elm } = require("../src/BokehPower.elm")

const app = Elm.BokehPower.init({
  node: document.getElementById('bokeh-power')
});
