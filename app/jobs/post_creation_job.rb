class PostCreationJob < ApplicationJob
  queue_as :default

  def perform(post)
    # BROADCAST TO FOLLOWERS AND ANYONE ON HIS USER PAGE

    followers_ids = post.creator.followers.pluck(:id)

    post_html = ApplicationController.render(
      partial: "posts/post",
      locals: { post: post, current_user: { id: nil }, just_created: true }
    )

    Turbo::StreamsChannel.broadcast_prepend_to(
      "posts-#{post.creator_id}",
      target: "posts-#{post.creator_id}",
      html: post_html,
    )

    Turbo::StreamsChannel.broadcast_prepend_to(
      "feed-#{post.creator_id}",
      target: "feed-#{post.creator_id}",
      html: post_html,
    )

    followers_ids.each_slice(1000) do |batch|
      PostCreationBatchJob.perform_later(batch, post_html)
    end
  end
end
