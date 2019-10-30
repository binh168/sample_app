module UsersHelper
  def gravatar_for user, size: Settings.size_gavatar 
    gravatar_id = Digest::MD5::hexdigest user.email.downcase 
    gravatar_url = Settings.gavatar
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def follow_submit
    current_user.active_relationships.build
  end

  def unfollow_submit
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
