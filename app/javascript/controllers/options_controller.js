import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static values = { creatorid: Number }
    connect() {
        // remove hidden tag from options on posts/comments if the user is the creator - checks meta value to compare with id in the div
        const meta = document.querySelector('meta[name="current-user-id"]')
        const currentUserId = meta ? parseInt(meta.content) : null
        if (currentUserId && currentUserId === this.creatoridValue) {
            this.element.classList.remove("hidden");
        };
    }
}