import consumer from "channels/consumer"

consumer.subscriptions.create("RequestChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("hello")
    // Called when there's incoming data on the websocket for this channel
    this.addSrc(data["id"])
  },

  addSrc(id) {
    const frame = document.getElementById(`user-follow-form-${id}`);
    frame.src = this.createUrl(id);
  },

  createUrl(id) {
    const url = new URL(`/user/${id}/follow_request/refresh`, window.location.origin);
    return url.toString();
  }
});
