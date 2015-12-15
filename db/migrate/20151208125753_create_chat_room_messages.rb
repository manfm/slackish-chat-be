class CreateChatRoomMessages < ActiveRecord::Migration
  def change
    create_table :chat_room_messages do |t|
      t.string :text
      t.boolean :incomming
      t.integer :sender_id
      t.string :sender_name
      t.references :user, index: true, foreign_key: true
      t.references :chat_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
