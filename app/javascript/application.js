// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"
import "channels"

import { Turbo } from "@hotwired/turbo-rails"

// Updates count on comments and posts - uses provided type and id so it doesn't need to know what type it is
Turbo.StreamActions.update_count = function() {
    const type = this.getAttribute("type");
    const id = this.getAttribute("id");
    const element = document.getElementById(`${type}-${id}`);
    if (!element) {
        return;
    };
    const like_count = this.getAttribute("likes_count");
    const comments_count = this.getAttribute("comments_count");
    if (like_count) {
        const likes_count_div = document.getElementById(`likes-${type}-number-${id}`);
        likes_count_div.textContent = like_count;
    }else if (comments_count) {
        const comments_count_div = document.getElementById(`comments-${type}-number-${id}`);
        comments_count_div.textContent = comments_count;
    };
};

// Triggers redirect to homepage - used if in a show page of a post/comment that got deleted
Turbo.StreamActions.redirect_to_home = function() {
    Turbo.visit("/");
};

// Adds class to element/s
Turbo.StreamActions.add_class = function() {
  const className = this.getAttribute("class")
  this.targetElements.forEach(element => element.classList.add(className))
};

// Removes class on element/s
Turbo.StreamActions.remove_class = function() {
  const className = this.getAttribute("class")
  this.targetElements.forEach(element => element.classList.remove(className))
};

// Prevent inbuilt links from trying to visit the page they are already in
document.addEventListener("turbo:before-visit", function(event) {
  if (event.detail.url === window.location.href) {
    event.preventDefault();
  }
});

// Prevent trix from accept non-images or images over 5MB
document.addEventListener("trix-file-accept", (event) => {
  const acceptedTypes = ["image/jpeg", "image/png", "image/webp", "image/jpg"];
  const maxBytes = 5 * 1024 * 1024; // 5MB limit
  const alertDiv = document.getElementById("alert");
  
  // Validate file type
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault();
    alertDiv.textContent = "Only images (JPEG, PNG, JPG, WEBP) are allowed."
    return;
  }

  // Validate file size
  if (event.file.size > maxBytes) {
    event.preventDefault();
    alertDiv.textContent = "Maximum size is 5MB."
  }
});