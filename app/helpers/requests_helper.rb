module RequestsHelper
  def get_other_user_from_request(current_user, request)
    current_user.id == request.user.id ? request.sender : request.user
  end
end
