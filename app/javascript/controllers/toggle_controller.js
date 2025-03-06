import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["togglableElement"]
  
  connect() {
    console.log("Toggle controller connected")
  }
  
  fire(event) {
    event.preventDefault()
    console.log("Toggle fire action triggered")
    this.togglableElementTarget.classList.toggle("d-none")
  }
}
