class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.integer :user_id
      t.integer :related_user_id
      t.string :text
      t.boolean :incomming

      t.timestamps null: false
    end
  end
end
