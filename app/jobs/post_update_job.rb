class PostUpdateJob < ApplicationJob
  queue_as :default

  # (post_id, data_type("likes_count", "comments_count", "content"), data(count, post record))
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
      Turbo::StreamsChannel.broadcast_action_to(
        "post-#{post_id}",
        action: "update_count",
        html: "",
        attributes: {
          id: post_id,
          data_type => data,
          type: "post"
        })
    end
  end
end
