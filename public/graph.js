let chart = null;

function renderGraph(json) {
  const ctx = document.getElementById('chart');
  if(chart != null) chart.destroy();
  chart = new Chart(ctx, json);
}

customElements.define('render-graph',
  class extends HTMLElement {
    constructor() { super(); }
    connectedCallback() { this.setTextContent(); }
    attributeChangedCallback() { this.setTextContent(); }
    static get observedAttributes() { return ['json']; }
    setTextContent() {
      const rawJson = this.getAttribute('json');
      const json = JSON.parse(rawJson);
      if(json != null) renderGraph(json);
    }
  }
);
