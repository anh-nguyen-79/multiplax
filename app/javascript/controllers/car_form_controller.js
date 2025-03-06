import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "step", "progress", "nextButton", "prevButton", "submitButton"]

  connect() {
    this.currentStep = 0
    this.updateFormState()
  }

  next(event) {
    event.preventDefault()
    console.log("Next button clicked")
    if (this.validateCurrentStep()) {
      this.currentStep++
      this.updateFormState()
    }
  }

  prev(event) {
    event.preventDefault()
    this.currentStep--
    this.updateFormState()
  }

  updateFormState() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle("d-none", index !== this.currentStep)
    })

    // Update progress bar
    if (this.hasProgressTarget) {
      const progressPercentage = (this.currentStep / (this.stepTargets.length - 1)) * 100
      this.progressTarget.style.width = `${progressPercentage}%`
    }

    // Show/hide buttons based on current step
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.classList.toggle("d-none", this.currentStep === 0)
    }

    if (this.hasNextButtonTarget && this.hasSubmitButtonTarget) {
      const isLastStep = this.currentStep === this.stepTargets.length - 1
      this.nextButtonTarget.classList.toggle("d-none", isLastStep)
      this.submitButtonTarget.classList.toggle("d-none", !isLastStep)
    }
  }

  validateCurrentStep() {
    const currentStepElement = this.stepTargets[this.currentStep];
    const requiredFields = currentStepElement.querySelectorAll('[required]');
    let isValid = true;
    
    // Réinitialiser les messages d'erreur précédents
    currentStepElement.querySelectorAll('.invalid-feedback').forEach(el => el.remove());
    currentStepElement.querySelectorAll('.is-invalid').forEach(el => {
      el.classList.remove('is-invalid');
    });
    
    // Vérifier chaque champ requis
    requiredFields.forEach(field => {
      if (!field.value.trim()) {
        isValid = false;
        field.classList.add('is-invalid');
        
        // Créer un message d'erreur
        const feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        feedback.textContent = `Ce champ est obligatoire`;
        field.parentNode.appendChild(feedback);
      }
      
      // Validation spécifique pour les champs numériques
      if (field.type === 'number' && field.value) {
        const min = parseInt(field.getAttribute('min'));
        const max = parseInt(field.getAttribute('max'));
        const value = parseInt(field.value);
        
        if (min !== null && value < min) {
          isValid = false;
          field.classList.add('is-invalid');
          
          const feedback = document.createElement('div');
          feedback.className = 'invalid-feedback';
          feedback.textContent = `La valeur minimale est ${min}`;
          field.parentNode.appendChild(feedback);
        }
        
        if (max !== null && value > max) {
          isValid = false;
          field.classList.add('is-invalid');
          
          const feedback = document.createElement('div');
          feedback.className = 'invalid-feedback';
          feedback.textContent = `La valeur maximale est ${max}`;
          field.parentNode.appendChild(feedback);
        }
      }
    });
    
    // Validations spécifiques par étape
    if (this.currentStep === 0) {
      // Validations pour l'étape 1 (informations de base)
      const phaseField = currentStepElement.querySelector('[name*="phase"]');
      const kmField = currentStepElement.querySelector('[name*="km"]');
      
      if (phaseField && phaseField.value.trim() && phaseField.value.length < 2) {
        isValid = false;
        phaseField.classList.add('is-invalid');
        
        const feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        feedback.textContent = 'La phase doit contenir au moins 2 caractères';
        phaseField.parentNode.appendChild(feedback);
      }
      
      if (kmField && kmField.value.trim()) {
        const kmValue = parseInt(kmField.value);
        if (isNaN(kmValue) || kmValue < 0) {
          isValid = false;
          kmField.classList.add('is-invalid');
          
          const feedback = document.createElement('div');
          feedback.className = 'invalid-feedback';
          feedback.textContent = 'Le kilométrage doit être un nombre positif';
          kmField.parentNode.appendChild(feedback);
        }
      }
    } else if (this.currentStep === 1) {
      // Validations pour l'étape 2 (détails supplémentaires)
      const priceField = currentStepElement.querySelector('[name*="price"]');
      const locationField = currentStepElement.querySelector('[name*="location"]');
      
      if (priceField && priceField.value.trim()) {
        const priceValue = parseFloat(priceField.value);
        if (isNaN(priceValue) || priceValue <= 0) {
          isValid = false;
          priceField.classList.add('is-invalid');
          
          const feedback = document.createElement('div');
          feedback.className = 'invalid-feedback';
          feedback.textContent = 'Le prix doit être supérieur à 0';
          priceField.parentNode.appendChild(feedback);
        }
      }
      
      if (locationField && locationField.value.trim() && locationField.value.length < 3) {
        isValid = false;
        locationField.classList.add('is-invalid');
        
        const feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        feedback.textContent = 'La localisation doit contenir au moins 3 caractères';
        locationField.parentNode.appendChild(feedback);
      }
    }
    
    // Si le formulaire n'est pas valide, afficher un message d'alerte
    if (!isValid) {
      // Faire défiler jusqu'au premier champ invalide
      const firstInvalidField = currentStepElement.querySelector('.is-invalid');
      if (firstInvalidField) {
        firstInvalidField.focus();
        firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
      
      // Afficher un message toast (optionnel)
      this.showValidationToast();
    }
    
    return isValid;
  }

  showValidationToast() {
    // Créer un toast pour informer l'utilisateur
    const toast = document.createElement('div');
    toast.className = 'toast align-items-center text-white bg-danger border-0 position-fixed top-0 end-0 m-3';
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    toast.innerHTML = `
      <div class="d-flex">
        <div class="toast-body">
          Veuillez corriger les erreurs avant de continuer.
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    `;
    
    document.body.appendChild(toast);
    
    // Initialiser et afficher le toast
    const bsToast = new bootstrap.Toast(toast, { autohide: true, delay: 3000 });
    bsToast.show();
    
    // Supprimer le toast du DOM après qu'il soit caché
    toast.addEventListener('hidden.bs.toast', () => {
      toast.remove();
    });
  }

  // Redirect to cars index when clicking back on first step
  backToIndex(event) {
    if (this.currentStep === 0) {
      event.preventDefault()
      window.location.href = "/cars"
    }
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