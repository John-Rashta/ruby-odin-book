import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "field", "submit" ]

  connect() {
    this.disableIfEmptyFields();
  }

  clear() {
    this.element.reset();
  }

  disableIfEmptyFields() {
    const fieldsEmpty = this.fieldTargets.every(field => {
      const trixEditor = field.editor;
      if (trixEditor) {
        const trixDoc = trixEditor.getDocument()
        return trixDoc.getAttachments().length === 0 && trixDoc.toString().trim().length === 0
      } else if (field.type === "file") {
        return field.files.length === 0;
      } else {
        return field.value.trim() === "";
      };
    });

    this.submitTarget.disabled = fieldsEmpty;
  }
}