class ChatRoomMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :chat_room

  def self.for_user_in_room(user_id, room_id)
    where(user_id: user_id, chat_room_id: room_id)
  end
end
