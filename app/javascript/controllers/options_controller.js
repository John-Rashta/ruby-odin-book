import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static values = { creatorid: Number }
    connect() {
        const meta = document.querySelector('meta[name="current-user-id"]')
        const currentUserId = meta ? parseInt(meta.content) : null
        if (currentUserId && currentUserId == this.creatoridValue) {
            this.element.classList.remove("hidden");
        };
    }
}