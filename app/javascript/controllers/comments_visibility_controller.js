import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["showButton", "hideButton", "commentSection", "commentMain", "commentsContainer"]
    show() {
        this.showButtonTarget.classList.add("hidden");
        this.commentSectionTarget.classList.remove("hidden");
        this.hideButtonTarget.classList.remove("hidden");
    }

    hide() {
        if (this.commentsContainerTarget.children.length === 0) {
            this.commentMainTarget.classList.add("hidden");
        }
        this.hideButtonTarget.classList.add("hidden");
        this.commentSectionTarget.classList.add("hidden");
        this.showButtonTarget.classList.remove("hidden");
    }
}