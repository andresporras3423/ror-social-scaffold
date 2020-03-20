require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'test post model' do
    it 'create valid post' do
      u1 = User.create(name: 'Oscar', email: 'q@q.com', password:'12345678', password_confirmation:'12345678')
      u1.save
      p1 = Post.new(user_id: u1.id, content: 'abc')
      expect(p1.valid?).to eq(true)
    end

    it 'create invalid post' do
      u1 = User.create(name: 'Oscar', email: 'q@q.com', password:'12345678', password_confirmation:'12345678')
      u1.save
      comment = 'a'*1100
      p1 = Post.new(user_id: u1.id, content: comment)
      expect(p1.valid?).to eq(false)
    end
  end
end