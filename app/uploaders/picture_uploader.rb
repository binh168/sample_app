class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [Settings.resize_to_limit, Settings.resize_to_limit]

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  storage :file
  
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
