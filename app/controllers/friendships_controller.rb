class FriendshipsController < ApplicationController
  def create
    f1 = Friendship.create(user_id: current_user.id, friend_id: params[:id])
    f1.save
    redirect_to '/'
  end
end
