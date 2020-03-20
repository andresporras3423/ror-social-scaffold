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

    it 'create invalid friendship' do
      f1 = Friendship.new(user_id: 3, friend_id: 4, confirmed: true)
      expect(f1.valid?).to eq(false)
    end

    it 'user cannot be his own friend' do
      f1 = Friendship.new(user_id: @u1.id, friend_id: @u1.id, confirmed: true)
      expect(f1.valid?).to eq(false)
    end

    it 'create two rows for each friendship' do
      f1 = Friendship.new(user_id: 1, friend_id: 2, confirmed: true)
      f1.save
      expect(Friendship.all.length).to eq(2)
    end

    it 'test unique for user_id and friend_id in database' do
      f1 = Friendship.new(user_id: 1, friend_id: 2, confirmed: true)
      f1.save
      f3 = Friendship.new(user_id: 2, friend_id: 1, confirmed: true)
      expect { f3.save }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
