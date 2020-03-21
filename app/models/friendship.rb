class Friendship < ApplicationRecord
  belongs_to :user
  has_one :friend, class_name: 'User'
end
