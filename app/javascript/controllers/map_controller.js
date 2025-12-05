import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    // Simple safety checks (also very helpful on Heroku)
    if (!this.apiKeyValue) {
      console.warn("[map] Missing Mapbox API key")
      return
    }

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,                    // container ID
      style: "mapbox://styles/mapbox/streets-v12" // style URL
    })

    this.map.addControl(new mapboxgl.NavigationControl())

    // When the style is ready, add markers and fit bounds
    this.map.on("load", () => {
      this.addMarkersToMap()
      this.fitMapToMarkers()
    })

    // Expose for debugging if needed
    window.myMap = this.map
  }

  // Called by window resize or Stimulus action if you add one
  resize() {
    if (this.map) {
      this.map.resize()
      this.fitMapToMarkers()
    }
  }

  // ---------- normal methods (no #private syntax) ----------

  addMarkersToMap() {
    if (!this.markersValue || this.markersValue.length === 0) {
      console.warn("[map] No markers provided")
      return
    }

    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const wrapper = document.createElement("div")
      wrapper.innerHTML = marker.marker_html

      // Use the actual marker element (firstChild), not the wrapper div
      const element =
        wrapper.firstElementChild || wrapper.firstChild || wrapper

      new mapboxgl.Marker(element)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  fitMapToMarkers() {
    if (!this.markersValue || this.markersValue.length === 0 || !this.map) {
      return
    }

    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach((marker) => {
      bounds.extend([marker.lng, marker.lat])
    })

    this.map.fitBounds(bounds, {
      padding: 50,
      maxZoom: 15,
      duration: 0
    })
  }
}
