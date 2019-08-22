class User < ApplicationRecord
  has_one_attached :avatar

  attr_accessor :copy_avatar_from_user_id

  # Callback that triggers an endless loop
  after_save :copy_avatar, if: :should_copy_avatar_from_user?

  def should_copy_avatar_from_user?
    copy_avatar_from_user_id.present?
  end

  # Copy a user avatar from a different user
  def copy_avatar
    user_to_copy_from = User.find_by(id: copy_avatar_from_user_id)
    avatar.attach(user_to_copy_from.avatar.blob)
  end
end
