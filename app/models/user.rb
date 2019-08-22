class User < ApplicationRecord
  has_one_attached :avatar

  attr_accessor :copy_avatar_from_user_id

  # Either of these methods will give the same result
  after_save :copy_avatar, if: :should_copy_avatar_from_user?
  # after_save :copy_avatar_via_tempfile, if: :should_copy_avatar_from_user?


  def should_copy_avatar_from_user?
    copy_avatar_from_user_id.present?
  end

  # Copy a user avatar from a different user
  def copy_avatar
    user_to_copy_from = User.find_by(id: copy_avatar_from_user_id)
    avatar.attach(user_to_copy_from.avatar.blob)
  end

  # Copy the avatar via a tempfile
  def copy_avatar_via_tempfile
    user_to_copy_from = User.find_by(id: copy_avatar_from_user_id)
    user_to_copy_from.avatar.blob.open do |tempfile|
      avatar.attach(
        io: tempfile,
        filename: user_to_copy_from.avatar.filename,
        content_type: user_to_copy_from.avatar.content_type
      )
    end
  end
end
