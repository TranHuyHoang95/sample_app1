class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :order_creat_at_desc, ->{order(created_at: :desc)}
  scope :belong_to_current_user, ->(id){where("user_id = ?", id)}
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.length.max_micropost}
  validates :image,
            content_type: {
              in: ["image/png", "image/jpg", "image/jpeg"],
              message: :image_invalid_type
            },
            size: {
              less_than: Settings.micropost.image_size.megabytes,
              message: :image_invalid_size
            }

  def display_image
    image.variant(resize_to_limit: [Settings.micropost.image_display,
      Settings.micropost.image_display])
  end
end
