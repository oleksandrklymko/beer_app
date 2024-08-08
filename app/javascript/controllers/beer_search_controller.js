import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input"]

    connect() {
        console.log("Stimulus controller connected!")
        this.timeout = null
    }

    search() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            if (this.inputTarget.value.length >= 3) {
                console.log("Submitting form...")
                this.element.requestSubmit()
            }
        }, 300)
    }
}
