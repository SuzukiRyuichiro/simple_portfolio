import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "price"]
  connect() {
    // console.log('price', this.priceTarget)
    fetch(`/api/v1/products/${this.element.dataset.productId}`)
      .then(response => response.json())
      .then(data => {
        // console.log('price', this.priceTarget.innerText, data.price)

        this.priceTarget.innerText = data.price
        // console.log('price', this.priceTarget.innerText, data.price)

      })
  }
}
