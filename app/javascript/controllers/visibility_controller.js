import { Controller } from "@hotwired/stimulus"
// Basic show and hide
export default class extends Controller {
    static targets = ["formDiv"]
    show() {
        this.formDivTarget.classList.remove("hidden");
    }

    hide() {
        this.formDivTarget.classList.add("hidden");
    }
}