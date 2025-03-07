import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = ["formContainer"]

  connect() {
    console.log("Car modal controller connected")
    this.modal = new Modal(this.element)
  }

  open(event) {
    event.preventDefault()
    
    // Charger le formulaire via AJAX
    fetch('/cars/new', {
      headers: {
        'Accept': 'text/html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => response.text())
    .then(html => {
      this.formContainerTarget.innerHTML = html
      this.modal.show()
      
      // S'assurer que le contrôleur Stimulus est correctement initialisé
      const application = this.application
      setTimeout(() => {
        application.controllers.forEach(controller => {
          if (controller.identifier === 'car-form') {
            console.log("Car form controller found and initialized")
          }
        })
      }, 100)
    })
    .catch(error => {
      console.error("Error loading form:", error)
    })
  }

  close() {
    this.modal.hide()
    
    // Nettoyer le formulaire après fermeture
    setTimeout(() => {
      this.formContainerTarget.innerHTML = ''
    }, 300)
  }
} 