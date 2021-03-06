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
  static targets = [ "results", 'input' ]

  connect() {

  }

  fetchResults() {
    if (this.inputTarget.value === ""){
      this.resultsTarget.innerHTML = "";
      this.inputTarget.classList.remove("form-radius-after-input");
    } else {
      fetch(`/api/v1/search/${this.inputTarget.value}`)
      .then(response => response.json())
      .then((data) => {
        if (data !== []) {
        this.inputTarget.classList.add("form-radius-after-input");
        }
        this.resultsTarget.innerHTML = "";
        data = data.slice(0,10)
        data.forEach((name) => {
          const list = `<a class="ist-group-item list-group-item-action p-1">${name.ticker}, ${name.name}</a>`;
          this.resultsTarget.insertAdjacentHTML("beforeend", list);
        });
      });
    }
  }
}
