class RequestsBroadcastJob < ApplicationJob
  queue_as :default

  # Broadcast removal of request from browser and/or trigger a reload of forms on the other user
  def perform(current_user, other_user, options = { action: "create", requestId: nil })
    RequestChannel.broadcast_to(
      other_user,
      id: current_user.id,
      action: options[:action],
      requestId: options[:requestId]
    )
  end
end
