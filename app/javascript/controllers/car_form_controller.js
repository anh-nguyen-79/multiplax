import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["errors"]

  connect() {
    console.log("Car form controller connected")
  }

  handleSubmit(event) {
    // Empêcher la redirection par défaut
    event.preventDefault()
    
    const [response] = event.detail.fetchResponse.response
    
    if (response.status === 422) {
      // Afficher les erreurs de validation
      response.json().then(errors => {
        this.showErrors(errors)
      })
    } else if (response.status === 200 || response.status === 201) {
      // Succès - fermer le formulaire et rafraîchir la page
      response.json().then(data => {
        // Fermer le formulaire
        this.element.closest('[data-controller="toggle"]').querySelector('[data-action*="toggle#fire"]').click()
        
        // Rafraîchir la liste des voitures sans recharger la page
        Turbo.visit(window.location.href, { action: "replace" })
        
        // Afficher un message de succès
        const flashMessage = document.createElement('div')
        flashMessage.className = 'alert alert-success text-center'
        flashMessage.textContent = 'Car was successfully created.'
        document.querySelector('.home-container').prepend(flashMessage)
        
        // Supprimer le message après 3 secondes
        setTimeout(() => {
          flashMessage.remove()
        }, 3000)
      })
    }
  }

  showErrors(errors) {
    const errorsTarget = this.errorsTarget
    errorsTarget.innerHTML = ''
    errorsTarget.classList.remove('d-none')
    
    const errorsList = document.createElement('ul')
    
    Object.entries(errors).forEach(([field, messages]) => {
      messages.forEach(message => {
        const errorItem = document.createElement('li')
        errorItem.textContent = `${field.charAt(0).toUpperCase() + field.slice(1)} ${message}`
        errorsList.appendChild(errorItem)
      })
    })
    
    errorsTarget.appendChild(errorsList)
  }
} 