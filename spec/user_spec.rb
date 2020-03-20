require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @u1 = User.create(name: 'Oscar', email: 'q@q.com', password: '12345678', password_confirmation: '12345678')
    @u1.save
    @p1 = Post.new(user_id: @u1.id, content: 'abc')
    @p1.save
  end
  context 'test user model creation' do
    it 'create valid user' do
      expect(@u1.valid?).to eq(true)
    end

    it 'create invalid user' do
      u2 = User.create(name: 'Oscar Andrés Russi Porras de la fuente', email: 'q@q.com',
                       password: '12345678', password_confirmation: '12345678')
      expect(u2.valid?).to eq(false)
    end
  end
  context 'test user model creation' do
    it 'bring list of created posts by this user' do
      expect(@u1.posts[0].content).to eq('abc')
    end

    it 'bring list of created comments by this user' do
      c1 = Comment.new(user_id: @u1.id, post_id: @p1.id, content: 'abc')
      c1.save
      expect(@u1.comments[0].content).to eq('abc')
    end

    it 'bring list of created likes by this user' do
      l1 = Like.new(user_id: @u1.id, post_id: @p1.id)
      l1.save
      expect(@u1.likes[0].post_id).to eq(@p1.id)
    end

    it 'created friendship between users' do
      u2 = User.create(name: 'salvaldor', email: 's@s.com', password: '12345678', password_confirmation: '12345678')
      u2.save
      f1 = Friendship.new(user_id: @u1.id, friend_id: u2.id, confirmed: true)
      f1.save
      expect(@u1.friendships[0].confirmed).to eq(true)
    end
  end
end
