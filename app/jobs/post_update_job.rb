class PostUpdateJob < ApplicationJob
  queue_as :default

  # (post_id, data_type("like_count", "comments_count", "content"), data("add", "remove", post record))
  def perform(post_id, data_type, data)
    # Do something later
    if data_type == "content"
      Turbo::StreamsChannel.broadcast_update_to(
        "post-#{post_id}",
        target: "post-content-#{post_id}",
        partial: "application/content",
        locals: { content: data }
      )
    else
      # CHANGE THIS TO CUSTOM TURBO ACTION BROADCAST
      # MAYBE USE CONTENT PARTIAL IN POST AND COMMENT
      Turbo::StreamsChannel.broadcast_action_to(
        "post-#{post_id}",
        action: "update_count",
        attributes: {
          post_id: post_id,
          data_type => data
        })
    end
  end
end
