class ChatRoomMessageService
  def self.create_new_message(text, sender_id, room_id)
    chat_room = ChatRoom.find(room_id)
    chat_room.last_message_at = DateTime.current

    messages_to_send = []
    chat_room.users.each do |chat_room_user|
      next if chat_room_user.id == sender_id

      message_to_send = create_message_for_friend text, chat_room_user.id, sender_id, room_id
      messages_to_send << message_to_send
    end

    my_message = duplicate_friends_message_for_sender(messages_to_send.first)

    ActiveRecord::Base.transaction do
      my_message.save!
      messages_to_send.each(&:save!)
      chat_room.save!
    end

    messages_to_send.each do |m|
      NotificationService.push_to_user User.find(m.user_id), 'new_chat_room_message', m
    end
    NotificationService.push_to_user User.find(my_message.user_id), 'new_chat_room_message', my_message

    my_message
  end

  def self.create_message_for_friend(text, friend_id, sender_id, chatroom_id)
    message_to_send = ChatRoomMessage.new
    message_to_send.text = text
    message_to_send.user_id = friend_id
    message_to_send.chat_room_id = chatroom_id
    message_to_send.sender_id = sender_id
    message_to_send.incomming = true

    message_to_send
  end

  def self.duplicate_friends_message_for_sender(friends_message)
    senders_message = ChatRoomMessage.new
    senders_message.text = friends_message.text
    senders_message.user_id = friends_message.sender_id
    senders_message.chat_room_id = friends_message.chat_room_id
    senders_message.incomming = false

    senders_message
  end
end
