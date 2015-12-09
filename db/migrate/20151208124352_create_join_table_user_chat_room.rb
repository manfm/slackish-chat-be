class CreateJoinTableUserChatRoom < ActiveRecord::Migration
  def change
    create_join_table :users, :chat_rooms do |t|
      # t.index [:user_id, :chat_room_id]
      # t.index [:chat_room_id, :user_id]
    end
  end
end
