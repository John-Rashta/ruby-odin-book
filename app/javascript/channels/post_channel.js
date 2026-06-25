import consumer from "channels/consumer"

consumer.subscriptions.create("PostChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // WILL NEED TO USE STIMULUS TO SUBSCRIBE AT LEAST
    // Called when there's incoming data on the websocket for this channel
    const element = document.getElementById(`post-${data["post_id"]}`);
    console.log("hello")
    if (element) {
      if (data["like_count"]) {
        const likes_count_div = document.getElementById(`like-post-number-${data["post_id"]}`);
        likes_count_div.textContent = parseInt(likes_count_div.textContent) + (data["like_count" === "add" ? 1 : -1]);
      }else if (data["comments_count"]) {
        const comments_count_div = document.getElementById(`comments-post-number-${data["post_id"]}`);
        comments_count_div.textContent = parseInt(comments_count_div.textContent) + (data["comments_count" === "add" ? 1 : -1]);
      }else if (data["content"]) {
        const content_div = document.getElementById(`post-content-${data["post_id"]}`);
        content_div.innerHTML = data["content"];
      } 
    };
  }
});
