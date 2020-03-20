require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'test comment model' do
    it 'create valid comment' do
      u1 = User.create(name: 'Oscar', email: 'q@q.com', password: '12345678', password_confirmation: '12345678')
      u1.save
      p1 = Post.new(user_id: u1.id, content: 'abc')
      p1.save
      c1 = Comment.new(user_id: u1.id, post_id: p1.id, content: 'abc')
      expect(c1.valid?).to eq(true)
    end

    it 'create invalid comment' do
      u1 = User.create(name: 'Oscar', email: 'q@q.com', password: '12345678', password_confirmation: '12345678')
      u1.save
      p1 = Post.new(user_id: u1.id, content: 'abc')
      p1.save
      comment = 'a' * 300
      c1 = Comment.new(user_id: u1.id, post_id: p1.id, content: comment)
      expect(c1.valid?).to eq(false)
    end
  end
end
