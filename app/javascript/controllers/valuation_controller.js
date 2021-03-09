import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "total"]
  connect() {
    fetch(`/api/v1/valuations/${this.element.dataset.currentUserId}`)
      .then(response => response.json())
      .then(data => {
        this.totalTarget.innerText = Number.parseFloat(data.valuation).toLocaleString('en-US', {maximumFractionDigits:2}) 
      })
  }
}
