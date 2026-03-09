require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test "Get liked posts" do
    liked_posts = users(:one).liked_posts
    assert_equal liked_posts[0], posts(:one)
  end

  test "Get Users That Liked" do
    users_that_liked = posts(:one).like_users
    assert_equal users_that_liked[0], users(:one)
  end
  # TRY CURRENT ATRIBUTES TO SET CURRENT USER TO BE ACCESIBLE IN MODELS- PROBABLY BEST SOLUTION
  test "Include passed user if he liked" do
    Current.current_user_id = users(:one).id
    post = Post.eager_load(:liked).all
    assert_equal post[0].liked[0], users(:one)
  end
end
