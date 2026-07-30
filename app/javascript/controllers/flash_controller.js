import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    flashTimeout = null
    connect() {
        // Trigger on connect if it already comes with a flash
        if (this.element.innerHTML.trim() !== "") {
            this.flashContentChanged()
        }
        // Create the observer to keep track of changes
        this.observer = new MutationObserver((mutationsList) => {
        for (const mutation of mutationsList) {
            if (mutation.type === "childList" && this.element.innerHTML.trim() !== "") {
            this.flashContentChanged()
            }
        }
        })

        this.observer.observe(this.element, { 
        childList: true,
        subtree: true
        })
    }

    disconnect() {
        if (this.observer) {
        this.observer.disconnect()
        }
        this.clearActiveTimeout()
    }

    flashContentChanged() {
        // Add the class and set a timeout to fade away
        this.clearActiveTimeout()

        this.element.classList.add("is-visible")
        
        this.flashTimeout = setTimeout(() => {
        this.fadeFlash()
        }, 4000)
    }

    clearActiveTimeout() {
        if (this.flashTimeout) {
        clearTimeout(this.flashTimeout)
        this.flashTimeout = null
        }
    }


    fadeFlash() {
        this.element.classList.remove("is-visible")

        this.flashTimeout = setTimeout(() => {
        this.element.innerHTML = ""
        }, 300)
    }
}