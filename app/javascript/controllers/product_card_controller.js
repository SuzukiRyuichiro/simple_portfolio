import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "price"]
  connect() {
    fetch(`/api/v1/products/${this.element.dataset.productId}`)
      .then(response => response.json())
      .then(data => {
        this.priceTarget.innerText = data.price
      })
  }
}
