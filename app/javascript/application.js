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
    const post_id = this.getAttribute("post_id");
    const element = document.getElementById(`post-${post_id}`);
    if (!element) {
        return;
    };
    const like_count = this.getAttribute("like_count");
    const comments_count = this.getAttribute("comments_count");
    if (like_count) {
        const likes_count_div = document.getElementById(`like-post-number-${post_id}`);
        likes_count_div.textContent = like_count;
    }else if (comments_count) {
        const comments_count_div = document.getElementById(`comments-post-number-${post_id}`);
        comments_count_div.textContent = comments_count;
    };
}