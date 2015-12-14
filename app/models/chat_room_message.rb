class ChatRoomMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :chat_room

  validates :text, length: { minimum: 1 }
  validates :incomming, inclusion: { in: [true, false] }
  validates :user_id, presence: true

  def self.for_user_in_room(user_id, room_id)
    where(user_id: user_id, chat_room_id: room_id)
  end
end
