import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";


export default class extends Controller {
  static targets = ["range", "startDate", "endDate", "price", "totalPrice", "days"];

  connect() {
    this.picker = flatpickr(this.rangeTarget, {
      mode: "range",
      minDate: "today",
      dateFormat: "Y-m-d",
      onChange: (selectedDates) => {
        if (selectedDates.length > 1) {
          const startDate = selectedDates[0]
          this.startDateTarget.value = startDate.toLocaleDateString("fr-FR");

          const endDate = selectedDates[1];
          this.endDateTarget.value = endDate.toLocaleDateString("fr-FR");
          this.calculate(selectedDates)
        }
      }
    });
  }

  calculate(selectedDates) {
    // console.log("⚡ Calcul du prix en cours...");
    const startDateValue = selectedDates[0];
    // console.log(" Start Date Value:", startDateValue);

    const endDateValue = selectedDates[1];
    // console.log("End Date Value:", endDateValue);

    // console.log("pricetest", this.priceTarget)
    const pricePerDay = parseFloat(this.priceTarget.innerHTML);
    // console.log(" Price Per Day:", pricePerDay);

    const startDate = new Date(startDateValue);
    const endDate = new Date(endDateValue);

    // console.log("Parsed Start Date:", startDate);
    // console.log("Parsed End Date:", endDate);


    const diffDays = Math.floor((endDate - startDate) / (1000 * 60 * 60 * 24));
    // console.log(" Nombre de jours:", diffDays);

    const totalPrice = diffDays * pricePerDay;
    // console.log(" Prix total:", totalPrice);

    if (endDateValue !== "" && startDateValue !== "") {
      // console.log("COUCOU");
      this.daysTarget.textContent = diffDays;
      this.totalPriceTarget.innerHTML = `${totalPrice}`;
    }

  }
}
