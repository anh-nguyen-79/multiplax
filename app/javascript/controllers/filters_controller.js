import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceFilter", "kmFilter", "phaseFilter", "yearFilter"]

  connect() {
    // Initialiser les valeurs des sliders
    this.updatePriceValue();
    this.updateKmValue();
  }

  togglePrice(event) {
    this.toggleFilter(this.priceFilterTarget, event.currentTarget);
  }

  toggleKm(event) {
    this.toggleFilter(this.kmFilterTarget, event.currentTarget);
  }

  togglePhase(event) {
    this.toggleFilter(this.phaseFilterTarget, event.currentTarget);
  }

  toggleYear(event) {
    this.toggleFilter(this.yearFilterTarget, event.currentTarget);
  }

  toggleFilter(filterElement, button) {
    // Si le filtre est déjà visible et qu'on clique sur le même bouton
    if (!filterElement.classList.contains('d-none') && button.classList.contains('active')) {
      // On ferme juste ce filtre
      filterElement.classList.add('d-none');
      button.classList.remove('active');
    } else {
      // Sinon, on ferme tous les filtres et on ouvre celui-ci
      this.closeAllFilters();
      filterElement.classList.remove('d-none');
      button.classList.add('active');
    }
  }

  closeAllFilters() {
    // Fermer tous les panneaux de filtre
    this.priceFilterTarget.classList.add("d-none");
    this.kmFilterTarget.classList.add("d-none");
    this.phaseFilterTarget.classList.add("d-none");
    this.yearFilterTarget.classList.add("d-none");
    
    // Désactiver tous les boutons
    document.querySelectorAll(".filter-button").forEach(button => {
      button.classList.remove("active");
    });
  }

  updatePriceValue() {
    const priceSlider = document.querySelector('input[name="price_min"]');
    const priceValue = document.querySelector('.price-value');
    
    if (priceSlider && priceValue) {
      priceSlider.addEventListener('input', function() {
        priceValue.textContent = `${this.value}€ - 500€`;
      });
    }
  }

  updateKmValue() {
    const kmSlider = document.querySelector('input[name="km_min"]');
    const kmValue = document.querySelector('.km-value');
    
    if (kmSlider && kmValue) {
      kmSlider.addEventListener('input', function() {
        kmValue.textContent = `${this.value} km - 100,000 km`;
      });
    }
  }
} 