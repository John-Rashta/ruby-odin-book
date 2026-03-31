require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test "Get Content" do
    content = likes(:one).contentable
    assert_equal content, posts(:one)
  end

  test "Get User" do
    user = likes(:one).user
    assert_equal user, users(:one)
  end
  test "Get liked posts" do
    liked_posts = users(:one).liked_posts
    assert_equal liked_posts[0], posts(:one)
  end

  test "Get Users That Liked Post" do
    users_that_liked = posts(:one).like_users
    assert_equal users_that_liked[0], users(:one)
  end
  test "Include passed user if he liked post" do
    Current.current_user_id = users(:one).id
    post = Post.eager_load(:liked).all
    assert_equal post[0].liked[0], users(:one)
  end

  test "Get liked comments" do
    liked_comments = users(:one).liked_comments
    assert_equal liked_comments[0], comments(:two)
  end

  test "Get Users That Liked Comment" do
    users_that_liked = comments(:two).like_users
    assert_equal users_that_liked[0], users(:one)
  end

  test "Include passed user if he liked comment" do
    Current.current_user_id = users(:one).id
    comment = Comment.eager_load(:liked).all
    assert_equal comment[1].liked[0], users(:one)
  end
end
