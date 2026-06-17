class RequestsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(current_user, other_user, options = { action: "create", requestId: nil })
    RequestChannel.broadcast_to(
      other_user,
      id: current_user.id,
      action: options[:action],
      requestId: options[:requestId]
    )
  end
end
