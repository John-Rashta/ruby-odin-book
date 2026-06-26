class CommentUpdateJob < ApplicationJob
  queue_as :default

  # (comment_id, data_type("likes_count", "comments_count", "content"), data(count, comment content))
  def perform(comment_id, data_type, data)
    # Do something later
    if data_type == "content"
      Turbo::StreamsChannel.broadcast_update_to(
        "comment-#{comment_id}",
        target: "comment-content-#{comment_id}",
        html: ERB::Util.html_escape(data)
      )
    else
      Turbo::StreamsChannel.broadcast_action_to(
        "comment-#{comment_id}",
        action: "update_count",
        attributes: {
          id: comment_id,
          data_type => data,
          type: "comment"
        })
    end
  end
end
