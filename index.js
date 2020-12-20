const { Elm } = require("./src/Main.elm")

const app = Elm.Main.init({
  node: document.getElementById('main')
});

let chart = null;

function renderGraph(datasets, option) {
  const ctx = document.getElementById('chart');
  if(chart != null) chart.destroy();
  chart = new Chart(ctx, {
    type: 'line',
    data: {
      datasets: datasets
    },
    options: {
      title: {
        display: false
      },
      scales: {
        xAxes: [{
          type: 'logarithmic',
          position: 'bottom',
          scaleLabel: {
            display: true,
            labelString: option.xAxes
          }
        }],
        yAxes: [{
          type: 'logarithmic',
          position: 'left',
          scaleLabel: {
            display: true,
            labelString: option.yAxes
          }
        }]
      }
    }
  });
}

customElements.define('render-graph',
  class extends HTMLElement {
    constructor() { super(); }
    connectedCallback() { this.setTextContent(); }
    attributeChangedCallback() { this.setTextContent(); }
    static get observedAttributes() { return ['json']; }
    setTextContent() {
      const json = this.getAttribute('json');
      const rawOption = this.getAttribute('option');
      const dataset = JSON.parse(json);
      const option = JSON.parse(rawOption);
      renderGraph(dataset, option);
    }
  }
);
