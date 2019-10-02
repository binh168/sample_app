module UsersHelper
  def gravatar_for user, size: Settings.size_gavatar 
    gravatar_id = Digest::MD5::hexdigest user.email.downcase 
    gravatar_url = Settings.gavatar
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
