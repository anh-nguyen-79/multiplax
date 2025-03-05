import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["startDate", "endDate", "price", "totalPrice", "days"];

  connect() {
    // console.log("⚡ Stimulus: RentalPriceController connecté !");
  }

  calculate() {
    // console.log("⚡ Calcul du prix en cours...");

    const startDateValue = this.startDateTarget.value;
    // console.log(" Start Date Value:", startDateValue);

    const endDateValue = this.endDateTarget.value;
    // console.log("End Date Value:", endDateValue);

    // console.log("pricetest", this.priceTarget)
    const pricePerDay = parseFloat(this.priceTarget.innerHTML);
    // console.log(" Price Per Day:", pricePerDay);

    const startDate = new Date(startDateValue + "T00:00:00");
    const endDate = new Date(endDateValue + "T00:00:00");

    // console.log("Parsed Start Date:", startDate);
    // console.log("Parsed End Date:", endDate);


    const diffDays = Math.floor((endDate - startDate) / (1000 * 60 * 60 * 24));
    // console.log(" Nombre de jours:", diffDays);

    const totalPrice = diffDays * pricePerDay;
    // console.log(" Prix total:", totalPrice);

    if (endDateValue !=="" && startDateValue !=="") {
      // console.log("COUCOU");
      this.daysTarget.textContent = diffDays;
      this.totalPriceTarget.innerHTML = `${totalPrice}`;
    }

  }
}
