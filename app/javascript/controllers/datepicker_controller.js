import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";


export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected!");

    // Target the inputs by ID (if they have specific IDs like start_date and end_date)
    const startDateInput = this.element.querySelector("#rental_start_date");
    const endDateInput = this.element.querySelector("#rental_end_date");

    if (startDateInput && endDateInput) {
      flatpickr([startDateInput, endDateInput], {
        enableTime: false,
        dateFormat: "Y-m-d",
        minDate: "today",
      });
    }
}
}
