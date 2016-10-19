class MusicSelection < ApplicationRecord
  belongs_to :user, primary_key: :id, foreign_key: :user_id
end
