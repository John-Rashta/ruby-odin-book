class ContentCreation
  def create_content(params)
    if params.has_key?(:image)
        post_content = PostImage.new
        post_content.image.attach(params[:image])
    else
      post_content = PostContent.new(content: params[:content])
    end
    post_content
  end

  # DOES NOT UPDATE- STILL NEEDS TO BE SAVED IF ITS CONTENT NOT IMAGE
  def patch_content_if_same(post, params)
    if params.has_key?(:image) && post.postable_type == "PostImage"
      post.postable.image.attach(params[:image])
      post
    elsif params.has_key?(:content) && post.postable_type == "PostContent"
      post.postable.content = params[:content]
      # Fixes an IO Error when trying to replace an image with another (First image has to be deleted first before inserting second one, if the delete happens after
      # than it won't cause an error) - still trying to figure out why exactly
      post.postable.content.body.to_s
      post
    else
      nil
    end
  end

  def update_or_replace_content(post, params)
    unless patch_content_if_same(post, params)
      post.postable.destroy
      post.postable = create_content(params)
    end
    post
  end
end
