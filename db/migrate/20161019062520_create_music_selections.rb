class CreateMusicSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :music_selections do |t|
      t.integer :user_id
      t.string :song
      t.boolean :queued, default: true

      t.timestamps
    end
  end
end
