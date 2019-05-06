class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  scope :user_id_like, -> (id){where "user_id = ?", id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.max_size.megabytes
    errors.add(:picture, t(".upload_error"))
  end
end
