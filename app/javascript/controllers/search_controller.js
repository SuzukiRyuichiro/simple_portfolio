// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "results", 'input', 'button' ]

  connect() {

  }

  fetchResults() {
    if (this.inputTarget.value === ""){
      this.resultsTarget.innerHTML = "";
      this.inputTarget.classList.remove('input-corner-on');
      this.buttonTarget.classList.remove('button-corner-on');
    } else {
      fetch(`/api/v1/search/${this.inputTarget.value}`)
      .then(response => response.json())
      .then((data) => {
        if (data.length === 0){
          this.resultsTarget.innerHTML = "";
          this.inputTarget.classList.remove('input-corner-on');
          this.buttonTarget.classList.remove('button-corner-on');
        } else {
          this.resultsTarget.innerHTML = "";
          this.inputTarget.classList.add('input-corner-on');
          this.buttonTarget.classList.add('button-corner-on');
          data.forEach((name) => {
            const list = `<a href="/products/${name.id}" class="list-group-item list-group-item-action-active" style="text-decoration-none; padding: 0.75rem 0.75rem;">${name.name} (${name.ticker})</a>`;
            this.resultsTarget.insertAdjacentHTML("beforeend", list);
        })
        }
      })
    }
  }
}
