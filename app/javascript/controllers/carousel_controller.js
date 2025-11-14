import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    // On desktop, block horizontal wheel/trackpad scrolling inside the carousel
    if (window.matchMedia("(pointer: fine)").matches) {
      this._blockWheel = (e) => {
        // If the intent is horizontal, block it so only arrows control the carousel
        if (Math.abs(e.deltaX) > Math.abs(e.deltaY)) {
          e.preventDefault()  // stop native horizontal scroll
        }
        // If it's mostly vertical, do nothing → page scrolls normally
      }
      this.trackTarget.addEventListener("wheel", this._blockWheel, { passive: false })
    }

    // Mobile needs no special handling; touch swipe works natively
  }

  disconnect() {
    if (this._blockWheel) {
      this.trackTarget.removeEventListener("wheel", this._blockWheel)
    }
  }

  prev() { this.#by(-1) }
  next() { this.#by(+1) }

  #by(dir) {
    const first = this.trackTarget.firstElementChild
    const cardWidth = first ? first.getBoundingClientRect().width : 300
    const gap = 16
    this.trackTarget.scrollBy({ left: dir * (cardWidth + gap), behavior: "smooth" })
  }
}
