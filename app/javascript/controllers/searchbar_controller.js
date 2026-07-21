import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.submit = this.debounce(this.submit.bind(this), 300);
  };

  connect() {
    const input = this.element.querySelector('input[name="search"]');
    
    this.previousSearchLength = input ? input.value.trim().length : 0;
  }

  submit(event) {
    const searchValue = event.target.value.trim();
    const currentSearchLength = searchValue.length;

    if (currentSearchLength > 0 || (currentSearchLength === 0 && this.previousSearchLength > 0)) {
        const url = new URL(this.element.action);
      
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

  preventEmpty(event) {
    const input = this.element.querySelector('input[name="search"]');
    const currentSearchLength = input ? input.value.trim().length : 0;

    if (currentSearchLength === 0 && this.previousSearchLength === 0) {
      event.preventDefault();
    };
  }

  debounce(func, delay) {
    let timeout;
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), delay);
    };
  }
}