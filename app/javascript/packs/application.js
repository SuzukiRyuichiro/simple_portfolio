// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import { initSelect2 } from '../components/init_select2';

document.addEventListener("turbolinks:load", function() {
  initSelect2();
});

require("chartkick")
require("chart.js")

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  const chart = Chartkick.chart['purchase'].getChartObject();
  setInterval(function(){
    const indexToUpdate = Math.round(Math.random() * 30);
    chart.data.datasets[0].data[indexToUpdate] = Math.random() *100;
    chart.update();
  }, 1000);
});

import "controllers"

