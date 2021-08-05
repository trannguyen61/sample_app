class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  PERMITTED_FIELDS = %i(content image).freeze

  delegate :name, to: :user, prefix: true

  scope :recent_posts, ->{order created_at: :desc}
  scope :post_by_user, ->(ids){where user_id: ids}

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.validation.post.max_length}
  validates :image, content_type: {
    in: Settings.validation.post.image_type,
    message: :invalid_format
  }, size: {
    less_than: Settings.validation.post.image_size.megabytes,
    message: :required_size
  }

  def display_image
    image.variant resize_to_limit: Settings.validation.post.img_resize
  end
end
