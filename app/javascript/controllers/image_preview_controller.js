import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvas", "source"];

  show() {
    const reader = new FileReader();

    reader.onload = function () {
      this.canvasTarget.src = reader.result;
    }.bind(this)

    reader.readAsDataURL(this.sourceTarget.files[0]);
  }
}