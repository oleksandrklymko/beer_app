import { Controller } from "stimulus"

export default class extends Controller {
    search(event) {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            this.element.requestSubmit()
        }, 300)
    }
}
