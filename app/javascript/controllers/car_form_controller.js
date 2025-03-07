import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "step", "progress", "nextButton", "prevButton", "submitButton"]

  connect() {
    console.log("Car form controller connected")
    this.currentStep = 0
    this.totalSteps = this.stepTargets.length
    console.log(`Total steps: ${this.totalSteps}`)
    this.updateUI()
  }

  next(event) {
    console.log("Next button clicked")
    event.preventDefault()
    
    if (this.validateCurrentStep()) {
      this.currentStep++
      this.updateUI()
      console.log(`Moving to step ${this.currentStep}`)
    }
  }

  prev(event) {
    console.log("Previous button clicked")
    event.preventDefault()
    
    if (this.currentStep > 0) {
      this.currentStep--
      this.updateUI()
      console.log(`Moving to step ${this.currentStep}`)
    }
  }

  validateCurrentStep() {
    const currentStep = this.stepTargets[this.currentStep]
    const requiredFields = currentStep.querySelectorAll('[required]')
    let isValid = true
    
    // Réinitialiser les messages d'erreur précédents
    currentStep.querySelectorAll('.is-invalid').forEach(field => {
      field.classList.remove('is-invalid')
    })
    
    requiredFields.forEach(field => {
      if (!field.value.trim()) {
        field.classList.add('is-invalid')
        isValid = false
      }
    })
    
    return isValid
  }

  updateUI() {
    console.log(`Updating UI for step ${this.currentStep}`)
    
    // Hide all steps
    this.stepTargets.forEach((step, index) => {
      step.classList.add('d-none')
    })
    
    // Show current step
    this.stepTargets[this.currentStep].classList.remove('d-none')
    
    // Update buttons
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.classList.toggle('d-none', this.currentStep === 0)
    }
    
    if (this.hasNextButtonTarget && this.hasSubmitButtonTarget) {
      const isLastStep = this.currentStep === this.totalSteps - 1
      this.nextButtonTarget.classList.toggle('d-none', isLastStep)
      this.submitButtonTarget.classList.toggle('d-none', !isLastStep)
    }
    
    // Update progress bar
    if (this.hasProgressTarget) {
      const progressPercentage = ((this.currentStep + 1) / this.totalSteps) * 100
      this.progressTarget.style.width = `${progressPercentage}%`
    }
  }

  backToIndex(event) {
    event.preventDefault()
    
    // Fermer le modal si présent
    const modal = this.element.closest('.modal')
    if (modal && modal.dataset.controller === 'car-modal') {
      const controller = this.application.getControllerForElementAndIdentifier(modal, 'car-modal')
      if (controller) {
        controller.close()
      }
    }
  }

  submit(event) {
    event.preventDefault()
    
    if (!this.validateCurrentStep()) {
      return
    }
    
    // Afficher un indicateur de chargement
    const submitButton = this.submitButtonTarget
    const originalText = submitButton.innerHTML
    submitButton.disabled = true
    submitButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...'
    
    const formData = new FormData(this.formTarget)
    
    // Ajouter des logs pour déboguer
    console.log("Submitting form to:", this.formTarget.action)
    
    fetch(this.formTarget.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => {
      console.log("Response status:", response.status)
      return response.json()
    })
    .then(data => {
      console.log("Response data:", data)
      
      if (data.success) {
        // Fermer le modal si présent
        const modal = this.element.closest('.modal')
        if (modal && modal.dataset.controller === 'car-modal') {
          const controller = this.application.getControllerForElementAndIdentifier(modal, 'car-modal')
          if (controller) {
            controller.close()
          }
        }
        
        // Afficher un message de succès
        this.showSuccessMessage("Car was successfully created!")
        
        // Rafraîchir la page pour afficher la nouvelle voiture
        window.location.href = data.redirect || window.location.href
      } else {
        // Réactiver le bouton
        submitButton.disabled = false
        submitButton.innerHTML = originalText
        
        // Afficher les erreurs
        this.showErrors(data.errors)
      }
    })
    .catch(error => {
      console.error("Error submitting form:", error)
      
      // Réactiver le bouton
      submitButton.disabled = false
      submitButton.innerHTML = originalText
      
      // Afficher un message d'erreur
      this.showErrorMessage("An error occurred. Please try again.")
    })
  }

  showSuccessMessage(message) {
    const flashMessage = document.createElement('div')
    flashMessage.className = 'alert alert-success text-center'
    flashMessage.textContent = message
    
    document.querySelector('.home-container').prepend(flashMessage)
    
    // Faire défiler vers le haut pour voir le message
    window.scrollTo({ top: 0, behavior: 'smooth' })
    
    // Supprimer le message après 3 secondes
    setTimeout(() => {
      flashMessage.remove()
    }, 3000)
  }

  showErrors(errors) {
    // Afficher les erreurs dans le formulaire
    if (errors) {
      Object.entries(errors).forEach(([field, messages]) => {
        const input = this.formTarget.querySelector(`[name="car[${field}]"]`)
        if (input) {
          input.classList.add('is-invalid')
          
          // Créer ou mettre à jour le message d'erreur
          let feedback = input.nextElementSibling
          if (!feedback || !feedback.classList.contains('invalid-feedback')) {
            feedback = document.createElement('div')
            feedback.className = 'invalid-feedback'
            input.parentNode.appendChild(feedback)
          }
          
          feedback.textContent = messages[0]
        }
      })
    }
  }

  showErrorMessage(message) {
    const flashMessage = document.createElement('div')
    flashMessage.className = 'alert alert-danger text-center'
    flashMessage.textContent = message
    
    document.querySelector('.home-container').prepend(flashMessage)
    
    // Faire défiler vers le haut pour voir le message
    window.scrollTo({ top: 0, behavior: 'smooth' })
    
    // Supprimer le message après 5 secondes
    setTimeout(() => {
      flashMessage.remove()
    }, 5000)
  }
} 