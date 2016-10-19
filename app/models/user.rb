class User < ApplicationRecord
  has_many :music_selections, primary_key: :id, foreign_key: :user_id
  has_many :comments, primary_key: :id, foreign_key: :user_id
end
