class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    friends_array = []
    friendships.each { |f| friends_array.push(f.friend) if f.confirmed }
    inverse_friendships.each { |f| friends_array.push(f.user) if f.confirmed }
    # friends_array += inverse_friendships.select { |f| f.confirmed }
    friends_array.compact
  end

  # Users who have yet to confirme friend requests
  def users_you_invited
    friendships.map { |f| f.friend unless f.confirmed }.compact
  end

  # Users who have requested to be friends
  def users_who_invite_you
    inverse_friendships.map { |f| f.user unless f.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def invitable(user)
    fr = Friendship.all
    if id == user.id ||
       fr.any? { |f| (f.user_id == id && f.friend_id == user.id) || (f.user_id == user.id && f.friend_id == id) }
      return false
    end

    true
  end

  def posts_mine_or_friends
    post = Post.all.ordered_by_most_recent.select { |p| p if p.user_id == id || friends.any? { |f| f.id == p.user_id } }
    post
  end
end
