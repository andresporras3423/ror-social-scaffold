require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @u1 = User.create(name: 'Oscar', email: 'q@q.com', password: '12345678', password_confirmation: '12345678')
    @u1.save
    @u2 = User.create(name: 'salvaldor', email: 's@s.com', password: '12345678', password_confirmation: '12345678')
    @u2.save
  end
  context 'test friendship model' do
    it 'create valid friendship' do
      f1 = Friendship.new(user_id: @u1.id, friend_id: @u2.id, confirmed: true)
      expect(f1.valid?).to eq(true)
    end

    it 'create valid friendship' do
      f1 = Friendship.new(user_id: @u1.id, friend_id: @u2.id, confirmed: true)
      f1.save
      expect(Friendship.all.length).to eq(2)
    end

    it 'create invalid friendship' do
      f1 = Friendship.new(user_id: 5, friend_id: 17, confirmed: true)
      expect(f1.valid?).to eq(false)
    end

    it 'destroy friendship' do
      f1 = Friendship.new(user_id: @u1.id, friend_id: @u2.id, confirmed: true)
      f1.save
      Friendship.destroy(f1.id)
      expect(Friendship.all.length).to eq(0)
    end
  end
end
