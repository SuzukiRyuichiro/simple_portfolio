import { finnhubLiveData } from '../plugins/finnhub_live_data';

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [] 

  connect() {
    // select the chartkick chart
    // go to finnhub to get data
    finnhubLiveData(this.element.dataset.symbol);
    // update the chart
  }
}