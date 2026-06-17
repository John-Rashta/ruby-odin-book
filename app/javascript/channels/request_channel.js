import consumer from "channels/consumer"

consumer.subscriptions.create("RequestChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    this.addSrc(data["id"]);
    this.removeRequest(data["action"], data["requestId"]);
  },

  removeRequest(action, requestId) {
    if (action === "destroy" && requestId) {
      const element = document.getElementById(`request-${requestId}`);
      if (element) {
        element.remove();
      };
    };
  },

  addSrc(id) {
    const frame = document.getElementById(`user-follow-form-${id}`);
    if (frame) {
      frame.src = this.createUrl(id);
    };
  },

  createUrl(id) {
    const url = new URL(`/user/${id}/follow_request/refresh`, window.location.origin);
    return url.toString();
  }
});
