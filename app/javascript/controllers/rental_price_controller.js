import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["startDate", "endDate", "price", "totalPrice", "days"];

  connect() {
    // console.log("⚡ Stimulus: RentalPriceController connecté !");
  }

  
}
