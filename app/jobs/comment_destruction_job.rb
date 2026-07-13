class CommentDestructionJob < ApplicationJob
  queue_as :default

  # ONLY CALL THIS IF COMMENT IS LAST COMMENT ON THAT COMMENT
  def perform(parent_comment_id)
    Turbo::StreamsChannel.broadcast_action_to(
      "comment-#{parent_comment_id}",
      target: "comments-main-#{parent_comment_id}",
      action: "add_class",
      html: "",
      attributes: {
        class: "hidden"
    })

    Turbo::StreamsChannel.broadcast_action_to(
      "comment-#{parent_comment_id}",
      targets: ".comment-visibility-1-#{parent_comment_id}",
      action: "add_class",
      html: "",
      attributes: {
        class: "hidden"
    })

    Turbo::StreamsChannel.broadcast_action_to(
      "comment-#{parent_comment_id}",
      target: "show-button-#{parent_comment_id}",
      action: "remove_class",
      html: "",
      attributes: {
        class: "hidden"
    })
  end
end
