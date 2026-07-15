// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"
import "channels"

import { Turbo } from "@hotwired/turbo-rails"

// CHANGE THIS TO WORK ON COMMENTS ASWELL- SHOULD BE ABLE TO TELL THE DIFFERENCE OR MORE INFO NEEDS TO BE PROVIDED
// JUST SEND IF STRING "post" OR "comment" AND USE THAT TO GET EVERYTHING- CHANGE POST_ID TO JUST ID- DONT HARD CODE POST OR COMMENT- JUST INSERT THE FETCHED STRING
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

Turbo.StreamActions.redirect_to_home = function() {
    Turbo.visit("/");
};

Turbo.StreamActions.add_class = function() {
  const className = this.getAttribute("class")
  this.targetElements.forEach(element => element.classList.add(className))
};

Turbo.StreamActions.remove_class = function() {
  const className = this.getAttribute("class")
  this.targetElements.forEach(element => element.classList.remove(className))
};

document.addEventListener("turbo:before-visit", function(event) {
  if (event.detail.url === window.location.href) {
    event.preventDefault();
  }
});