class CommentCreationJob < ApplicationJob
  queue_as :default

  # Broadcasts comments creations - prepends on show pages and appends bellow a comment in comment section
  # Depth needed to keep track for comment section to not get too big
  # First needed to remove hidden from the div that contains the comments
  def perform(comment, depth = 1, first = false)
    comment_record = comment
    comment_html = ApplicationController.render(
      partial: "comments/comment",
      locals: { comment: comment_record, current_user: { id: nil }, just_created: true, depth: depth }
    )

    # If comment has a parent comment broadcast to the comment and it's show page
    if comment_record.comment_id
      Turbo::StreamsChannel.broadcast_prepend_to(
        "comment-show-#{comment_record.comment_id}",
        target: "comment-show-comments-#{comment_record.comment_id}",
        html: comment_html,
      )
      Turbo::StreamsChannel.broadcast_append_to(
        "comment-#{comment_record.comment_id}",
        target: "comment-comments-#{comment_record.comment_id}",
        html: comment_html,
      )

      # If it's the first comment reveal the div container
      if first
        Turbo::StreamsChannel.broadcast_action_to(
        "comment-#{comment_record.comment_id}",
        target: "comments-main-#{comment_record.comment_id}",
        action: "remove_class",
        html: "",
        attributes: {
          class: "hidden"
        })
      end
    else
      # If no parent comment just append to Post page
      Turbo::StreamsChannel.broadcast_prepend_to(
        "post-show-#{comment_record.post_id}",
        target: "post-comments-#{comment_record.post_id}",
        html: comment_html,
      )
    end
  end
end
