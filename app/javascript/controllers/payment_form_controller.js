import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment-form"
export default class extends Controller {

  static targets = ["creditSelectField", "amountInput", "amountHelpText"]
  
  onMethodChange(event) {
    if (event.target.value === "client_credit") {
      this.creditSelectFieldTarget.classList.remove("hidden")
      this.amountInputTarget.disabled = true
      this.amountHelpTextTarget.textContent = "* Amount set automatically from the selected credit"
      this.amountHelpTextTarget.classList.remove("hidden")
    } else {
      this.creditSelectFieldTarget.classList.add("hidden")
      this.amountInputTarget.disabled = false
      this.amountHelpTextTarget.textContent = ""
      this.amountHelpTextTarget.classList.add("hidden")
    }
  }
  
}
