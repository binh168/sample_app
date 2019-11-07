class Micropost < ApplicationRecord
  belongs_to :user
  
  mount_uploader :picture, PictureUploader
  PARAMS_MICROPOST = %i(content picture).freeze
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_maximum}
  validate  :picture_size

  scope :order_micropost, ->{order created_at: :desc}

  private

  def picture_size
    return if  picture.size <= Settings.picture_size.megabytes
    errors.add(:picture, t(".picture_size"))
  end
end
