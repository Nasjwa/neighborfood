import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    "dateLabel", "dateOptions",
    "hourLabel", "hourOptions",
    "minuteLabel", "minuteOptions",
    "hiddenField"
  ]

  connect() {
    this.type = this.element.dataset.nfdatetimeType
  }

  /* ---------------------------- DROPDOWN TOGGLES --------------------------- */

  toggleDate() {
    if (this.type === "end") return
    if (this.hasDateOptionsTarget) {
      this.dateOptionsTarget.classList.toggle("open")
    }
  }

  toggleHour() {
    if (this.hasHourOptionsTarget) {
      this.hourOptionsTarget.classList.toggle("open")
    }
  }

  toggleMinute() {
    if (this.hasMinuteOptionsTarget) {
      this.minuteOptionsTarget.classList.toggle("open")
    }
  }

  /* ------------------------------- SELECTIONS ------------------------------ */

  chooseDate(e) {
    const value = e.target.dataset.value
    const text = e.target.dataset.text

    this.dateLabelTarget.textContent = text
    this.dateLabelTarget.dataset.value = value

    if (this.hasDateOptionsTarget) {
      this.dateOptionsTarget.classList.remove("open")
    }

    const wrapper = this.element.parentElement.querySelector("[data-nfdatetime-type='end']")
    const endC = this.application.getControllerForElementAndIdentifier(wrapper, "nfdatetime")

    endC.dateLabelTarget.textContent = text
    endC.dateLabelTarget.dataset.value = value
    endC.updateValue()

    this.updateValue()
  }

  chooseHour(e) {
    this.hourLabelTarget.textContent = e.target.dataset.value

    if (this.hasHourOptionsTarget) {
      this.hourOptionsTarget.classList.remove("open")
    }

    this.validateEndAfterStart()
    this.updateValue()
  }

  chooseMinute(e) {
    this.minuteLabelTarget.textContent = e.target.dataset.value

    if (this.hasMinuteOptionsTarget) {
      this.minuteOptionsTarget.classList.remove("open")
    }

    this.validateEndAfterStart()
    this.updateValue()
  }

  /* ---------------------- VALIDATION (end >= start) ------------------------ */

  validateEndAfterStart() {
    if (this.type !== "end") return

    const start = this.element.parentElement.querySelector("[data-nfdatetime-type='start']")
    const startC = this.application.getControllerForElementAndIdentifier(start, "nfdatetime")

    const sHour = parseInt(startC.hourLabelTarget.textContent)
    const sMin  = parseInt(startC.minuteLabelTarget.textContent)
    const eHour = parseInt(this.hourLabelTarget.textContent)
    const eMin  = parseInt(this.minuteLabelTarget.textContent)

    if (isNaN(sHour) || isNaN(eHour)) return

    if (eHour < sHour || (eHour === sHour && eMin < sMin)) {
      this.hourLabelTarget.textContent = String(sHour).padStart(2, "0")
      this.minuteLabelTarget.textContent = String(sMin).padStart(2, "0")
    }
  }

  /* ------------------------------ UPDATE FIELD ----------------------------- */

  updateValue() {
    const date = this.dateLabelTarget.dataset.value
    const hour = this.hourLabelTarget.textContent
    const min  = this.minuteLabelTarget.textContent

    if (!date || hour === "--" || min === "--") return

    this.hiddenFieldTarget.value = `${date} ${hour}:${min}`
  }
}
