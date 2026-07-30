import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.submit = this.debounce(this.submit.bind(this), 300);
  };

  connect() {
    const input = this.element.querySelector('input[name="search"]');
    
    // Setup previous length to be equal to initial input length
    this.previousSearchLength = input ? input.value.trim().length : 0;
  }

  submit(event) {
    // Trim and get current length
    const searchValue = event.target.value.trim();
    const currentSearchLength = searchValue.length;

    // If current length is bigger than 0 or if it's 0 and previous length is bigger than 0 proceed to send the request to search users
    if (currentSearchLength > 0 || (currentSearchLength === 0 && this.previousSearchLength > 0)) {
        const url = new URL(this.element.action);
      
        // Remove search from url if it's empty
        if (searchValue.length > 0) {
            url.searchParams.set("search", searchValue);
        } else {
            url.searchParams.delete("search");
        };
        Turbo.navigator.history.replace(url);
        this.element.requestSubmit();
    };

    this.previousSearchLength = currentSearchLength;
  }

  debounce(func, delay) {
    let timeout;
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), delay);
    };
  }
}