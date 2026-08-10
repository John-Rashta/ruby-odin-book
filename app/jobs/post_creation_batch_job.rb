class PostCreationBatchJob < ApplicationJob
  queue_as :default

  # Batch broadcast to feeds of followers
  def perform(followers_ids, html)
    followers_ids.each do |follower_id|
      stream_name = "feed-#{follower_id}"

      Turbo::StreamsChannel.broadcast_prepend_to(
        stream_name,
        target: stream_name,
        html: html
      )
    end
  end
end
