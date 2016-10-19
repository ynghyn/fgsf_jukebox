class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamp :last_visited

      t.timestamps
    end
  end
end
