require 'rails_helper'

RSpec.describe Like, type: :model do
  context 'test like model' do
    it 'create valid like' do
      u1 = User.create(name: 'Oscar', email: 'q@q.com', password:'12345678', password_confirmation:'12345678')
      u1.save
      p1 = Post.new(user_id: u1.id, content: 'abc')
      p1.save
      l1 = Like.new(user_id: u1.id, post_id: p1.id)
      expect(l1.valid?).to eq(true)
    end

    it 'create invalid post' do
      l1 = Like.new(user_id: 2, post_id: 2)
      expect(l1.valid?).to eq(false)
    end
  end
end