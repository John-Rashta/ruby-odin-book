import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["editDiv", "mainDiv"]
    show() {
        this.mainDivTarget.classList.add("hidden");
        this.editDivTarget.classList.remove("hidden");
    }

    hide() {
        this.editDivTarget.classList.add("hidden");
        this.mainDivTarget.classList.remove("hidden");
    }
}