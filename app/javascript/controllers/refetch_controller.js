import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  userFormRefetch() {
    const frame = document.getElementById("exercise_details")
    const currentSrc = this.element.getAttribute("src");
    if (!currentSrc) {
        return;
    }

    const url = new URL(currentSrc, window.location.origin)
    url.searchParams.set("_t", Date.now()) // Force cache bust
    
    this.element.src = url.toString()
  }
}