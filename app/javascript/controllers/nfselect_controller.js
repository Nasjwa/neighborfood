import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hidden", "label", "options"]

  toggle() {
    this.optionsTarget.classList.toggle("open")
  }

  choose(event) {
    const value = event.currentTarget.dataset.value
    this.hiddenTarget.value = value
    this.labelTarget.textContent = value
    this.optionsTarget.classList.remove("open")
  }

  connect() {
    document.addEventListener("click", this.outsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick)
  }

  outsideClick = (event) => {
    if (!this.element.contains(event.target)) {
      this.optionsTarget.classList.remove("open")
    }
  }
}
