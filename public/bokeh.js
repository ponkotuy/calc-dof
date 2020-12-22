const { Elm } = require("../src/Bokeh.elm")

const app = Elm.Bokeh.init({
  node: document.getElementById('bokeh')
});
