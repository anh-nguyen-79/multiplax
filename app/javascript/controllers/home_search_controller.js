import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "location", "startDate", "endDate"]

  connect() {
    console.log("Home search controller connected")
    
    // Initialiser les dates avec des valeurs par défaut si elles ne sont pas définies
    if (!this.startDateTarget.value) {
      const tomorrow = new Date()
      tomorrow.setDate(tomorrow.getDate() + 1)
      this.startDateTarget.value = this.formatDate(tomorrow)
    }
    
    if (!this.endDateTarget.value) {
      const nextWeek = new Date()
      nextWeek.setDate(nextWeek.getDate() + 8)
      this.endDateTarget.value = this.formatDate(nextWeek)
    }
  }
  
  submit(event) {
    // Vérifier que les dates sont valides avant de soumettre
    if (!this.validateDates()) {
      event.preventDefault()
    }
  }
  
  validateDates() {
    const startDate = new Date(this.startDateTarget.value)
    const endDate = new Date(this.endDateTarget.value)
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    
    if (startDate < today) {
      alert("Start date cannot be in the past")
      return false
    }
    
    if (endDate <= startDate) {
      alert("End date must be after start date")
      return false
    }
    
    return true
  }
  
  formatDate(date) {
    return date.toISOString().split('T')[0]
  }
} 