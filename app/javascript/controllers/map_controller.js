import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    console.log("Map controller connected"); // Pour le débogage
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [2.3522, 48.8566], // Paris par défaut
      zoom: 13
    })
    
    if (this.markersValue && this.markersValue.length > 0) {
      console.log("Markers:", this.markersValue); // Pour le débogage
      this.addMarkersToMap()
      this.fitMapToMarkers()
    } else {
      console.log("No markers available"); // Pour le débogage
    }
  }

  addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // Créer un élément HTML pour le popup
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      
      // Créer et ajouter le marker avec le popup
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }
  
  fitMapToMarkers() {
    if (this.markersValue.length === 0) return
    
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}