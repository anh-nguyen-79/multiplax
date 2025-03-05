import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

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
    
    this.addGeocoder()
    
    if (this.markersValue && this.markersValue.length > 0) {
      console.log("Markers:", this.markersValue); // Pour le débogage
      this.#addMarkersToMap()
      this.fitMapToMarkers()
    } else {
      console.log("No markers available"); // Pour le débogage
    }
  }

  #addMarkersToMap() {
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
  
  addGeocoder() {
    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      placeholder: 'Search for a location',
      marker: false, // Ne pas ajouter de marqueur lors de la recherche
      language: 'fr' // Langue française
    })
    
    this.map.addControl(geocoder)
    
    // Optionnel : Ajouter un événement pour réagir lorsqu'un résultat est sélectionné
    geocoder.on('result', (event) => {
      const searchCoordinates = event.result.center; // [longitude, latitude]
      
      // Filtrer les voitures par proximité (exemple)
      const maxDistance = 10; // km
      
      // Envoyer une requête AJAX pour obtenir les voitures à proximité
      fetch(`/cars/nearby?lng=${searchCoordinates[0]}&lat=${searchCoordinates[1]}&distance=${maxDistance}`)
        .then(response => response.json())
        .then(data => {
          // Mettre à jour les marqueurs sur la carte
          // ...
        });
    })
  }
}
