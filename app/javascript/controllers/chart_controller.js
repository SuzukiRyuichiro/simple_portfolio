import { finnhubLiveData } from '../plugins/finnhub_live_data';

import { Controller } from "stimulus"
// import { charts } from 'chartkick';

export default class extends Controller {
  static targets = ['price'] 

  connect() {
    const onMessage = (event, chart) => {
      // console.log(chart)
      // console.log(chartID)
      console.log(event, this.element.dataset.symbol)
      const data = JSON.parse(event.data).data
      console.log(data)
      if (data[0].s === this.element.dataset.symbol) {
        const dataPoint = [data[0].t, data[0].p]
        this.priceTarget.innerText = data[0].p
        // console.log(data)
        // console.log(dataPoint)
        // console.log('Message from server ', event.data);
        const newData = chart.getData()
        // this.element.dataset.initialized ? newData[0].data.push(dataPoint) : newData[0].data = [dataPoint];
        // this.element.dataset.initialized = true;
        // console.log(newData);
        newData[0].data.push(dataPoint);
        const newOptions = {
            backgroundColor: 'red',
            scales: {
              yAxes: [{
                  ticks: {
                      beginAtZero: false,
                      min: -10000,
                      max: 100000,
                  }
              }]
          }
        };
        // chart.setOptions(newOptions)
        // chart.updateData(newData)
        // // chart.options.title.text = 'as;kja'
        // // chart.update();
        // // console.log(chart.getOptions())
        // chart.redraw();
        chart.options.scales.yAxes[0].ticks.beginAtZero = false
        chart.options.scales.yAxes[0].ticks.max = 40000
        chart.options.scales.yAxes[0].ticks.min = 30000
        chart.update()
      }
    }
    window.addEventListener('load', (event) => {
      console.log('DOM fully loaded and parsed');
      // select the chartkick chart
      this.chart = Chartkick.charts[`chart-${this.element.dataset.productId}`]
      // console.log(this.chart)
      // console.log(chart.getChartObject());
      // console.log(chart.getData());
      
      
      // go to finnhub to get data
      finnhubLiveData(window.socket, this.element.dataset.symbol, (event) => onMessage(event, this.chart));
      // update the chart
    });
  }
}