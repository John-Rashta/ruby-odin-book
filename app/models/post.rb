class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :creator, class_name: "User"
  has_many :likes, as: :contentable, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(user_id: Current.current_user_id) }, as: :contentable, class_name: "Like"
  has_many :comments, dependent: :destroy
  has_many :direct_comments, -> { where(comment_id: nil).order(created_at: :desc) }, foreign_key: "post_id", class_name: "Comment", dependent: :destroy
  validates :creator_id, numericality: { only_integer: true }
  belongs_to :postable, polymorphic: true, dependent: :destroy
  # after_create_commit :add_post
  # after_update_commit :update_post
  after_destroy_commit :delete_post

  private

  def add_post
    PostCreationJob.perform_later(self)
  end

  def update_post
    # SHOULD BE MOVED TO A JOB AND BROADCAST FROM CONTROLLER SHOULD DO LIKES AND COMMENTS COUNTS ASWELL THROUGH THIS CHANNEL IN CONTROLLERS- JUST DO IT FROM CONTROLLERS
    # DELEGATED TO JOBS- MAYBE JUST DO +1 OR -1 INSTEAD SO WE DONT HAVE TO FETCH POST FOR EVERY LIKE AND COMMENT CREATION
    # CAN CHECK IN THE JOB WHICH TYPE WE SENDING LIKES COUNT COMMS COUNT OR CONTENT AND ACT ACCORDINGLY- REMEMBER TO FINISH JAVASCRIPT PART- CHECK IF VALUES ARE PRESENT
    # AND THAN UPDATE ACORDINGLY
    # CHECK IF STREAM GETS REMOVED WHEN PARTIAL DELETED
  end

  def delete_post
    broadcast_remove_to(
      "post-#{self.id}",
      target: "post-#{self.id}"
    )
  end
end
