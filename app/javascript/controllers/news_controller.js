import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container" ]

 connect() {
    fetch(`/api/v1/news`)
      .then(response => response.json())
      .then(data => {
        data.forEach((article) => {
          this.containerTarget.insertAdjacentHTML('afterbegin', article)
        })
      })
  }
}
