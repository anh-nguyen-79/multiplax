import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";


export default class extends Controller {
  static targets = ["start", "end"];
  connect() {
    this.picker = flatpickr(this.startTarget, {
      mode: "range",
      minDate: "today",
      dateFormat: "Y-m-d",
      onChange: this.updateEndDate.bind(this)
    });
  }
  updateEndDate(selectedDates) {
    if (selectedDates.length > 1) {
      const endDate = selectedDates[1];
      this.endTarget.value = endDate.toLocaleDateString("fr-CA");
    }
  }
}
