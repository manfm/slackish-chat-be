class ChatRoom < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.for_user(user_id)
    User.find(user_id).chat_rooms.order(last_message_at: :desc)
  end

  before_create do
    self.last_message_at = DateTime.current
  end
end
