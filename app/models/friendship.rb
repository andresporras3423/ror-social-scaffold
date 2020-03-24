class Friendship < ApplicationRecord
  after_save :create_friendship
  after_destroy :destroy_friendship
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def create_friendship
    return if Friendship.where(user_id: friend_id, friend_id: user_id) != []

    user_friendship1 = Friendship.create(user_id: friend_id, friend_id: user_id)
    user_friendship1.save
  end

  def destroy_friendship
    return if Friendship.where(user_id: friend_id, friend_id: user_id) == []

    user_friendship1 = Friendship.find { |f| f.user_id == friend_id && f.friend_id == user_id }
    Friendship.destroy(user_friendship1.id)
  end

  def check_not_my_own_friend
    errors.add(:user_id, 'user cannot be his own friend') if user_id == friend_id
  end
end
