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
    } else {
      fetch(`/api/v1/search/${this.inputTarget.value}`)
      .then(response => response.json())
      .then((data) => {
        this.resultsTarget.innerHTML = "";
        console.log(data);
        data.forEach((name) => {
          const list = `<a href="/products/${name.id}" class="list-group-item list-group-item-action-active" style="text-decoration-none">(${name.ticker})${name.name}</a>`;
          this.resultsTarget.insertAdjacentHTML("beforeend", list);
        });
      });
    }
  }
}
