require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "attaching an image via callback" do
    # Setup the first user with an avatar
    user_to_copy_avatar_from = User.new
    user_to_copy_avatar_from.avatar.attach(
      io: File.open(Rails.root.join('test', 'fixtures', 'files', 'avatar.jpg')),
      filename: 'avatar.jpg',
      content_type: 'image/jpg'
    )
    user_to_copy_avatar_from.save!

    # Try to copy the user's avatar to an existing user
    user = User.create

    # Update the user
    user.copy_avatar_from_user_id = user_to_copy_avatar_from.id
    user.save!

    # I'm assuming the name should be the same? Regardless, we don't get here due to a "SystemStackError"
    assert user.avatar.blob.filename, user_to_copy_avatar_from.avatar.blob.filename
  end
end
