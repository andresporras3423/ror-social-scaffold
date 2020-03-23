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
    friends_array
  end

  # Users who have yet to confirme friend requests
  def users_you_invited
    users=[]
    friendships.select {|f| users.push(f.friend) if f.confirmed==nil && inverse_friendships.none?{|f2| f.friend_id==f2.user_id && f.user_id==f2.friend_id && f.id>f2.id}}
    users
  end

  # Users who have requested to be friends
  def users_who_invite_you
    users=[]
    friendships.each {|f| users.push(f.friend) if f.confirmed==nil && inverse_friendships.none?{|f2| f.friend_id==f2.user_id && f.user_id==f2.friend_id && f.id<f2.id}}
    users
  end

  # def confirm_friend(user)
  #   friendship = inverse_friendships.find { |f| f.user == user }
  #   friendship.confirmed = true
  #   friendship = friendships.find { |f| f.user == user }
  #   friendship.save
  # end

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
