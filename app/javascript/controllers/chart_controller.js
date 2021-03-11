import { finnhubLiveData } from '../plugins/finnhub_live_data';

import { Controller } from "stimulus"
// import { charts } from 'chartkick';

export default class extends Controller {
  static targets = ['price'] 

  connect() {
    this.newData = []
    window.addEventListener('load', (event) => {
      // Start websocket connection
      finnhubLiveData(window.socket, this.element.dataset.symbol, (event) => onMessage(event));
    });
    const onMessage = (event) => {
      const data = JSON.parse(event.data).data
      if (!data) return
      for (let el of data) {
        if (el.s === this.element.dataset.symbol && el.t && el.p) {
          this.priceTarget.innerText = el.p
          const dataPoint = [new Date(el.t), el.p]
          // Add new data point
          this.newData.push(dataPoint)
          // Update chart if enough data points
          if (this.newData.length > 2) {
            this.chart = Chartkick.charts[`chart-${this.element.dataset.productId}`]
            const chartData = this.chart.getData()
            chartData[0].data = this.newData
            this.chart.updateData(chartData)
            // Change y axis min and max
            const max = Math.max(...this.newData.map(el => el[1]))
            const min = Math.min(...this.newData.map(el => el[1]))
            this.chart.chart.options.scales.yAxes[0].ticks.beginAtZero = false
            this.chart.chart.options.scales.yAxes[0].ticks.max = max
            this.chart.chart.options.scales.yAxes[0].ticks.min = min
            this.chart.chart.options.scales.yAxes[0].ticks.display = false
            this.chart.chart.options.scales.xAxes[0].ticks.display = false
            this.chart.chart.options.elements.line.tension = 0.1
            this.chart.chart.update()
          }
          break;
        }
      }
    }
  }
};