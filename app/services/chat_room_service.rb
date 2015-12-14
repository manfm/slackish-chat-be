class ChatRoomService
  def self.create_new_chat_room(name, users_id)
    chat_room = ChatRoom.new(name: name)

    users = []
    users_id.each do |id|
      user = User.find(id)
      user.chat_rooms << chat_room
      users << user
    end

    ActiveRecord::Base.transaction do
      chat_room.save!
      users.each(&:save!)
    end

    chat_room
  end
end
