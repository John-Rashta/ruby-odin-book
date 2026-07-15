class CommentCreationJob < ApplicationJob
  queue_as :default

  def perform(comment, depth = 1, first = false)
    # FOR COMMENT SHOW COMMENTS NEED TO PREPEND- FOR POST COMMENTS ASWELL - ONLY COMMENT COMMENTS IS APPEND
    comment_record = comment
    comment_html = ApplicationController.render(
      partial: "comments/comment",
      locals: { comment: comment_record, current_user: { id: nil }, just_created: true, depth: depth }
    )

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
      Turbo::StreamsChannel.broadcast_prepend_to(
        "post-show-#{comment_record.post_id}",
        target: "post-comments-#{comment_record.post_id}",
        html: comment_html,
      )
    end
  end
end
