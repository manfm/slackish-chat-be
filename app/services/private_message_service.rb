class PrivateMessageService
  def self.create_message_for_friend(text, friend_id, sender_id)
    message_to_send = PrivateMessage.new
    message_to_send.text = text
    message_to_send.user_id = friend_id
    message_to_send.related_user_id = sender_id
    message_to_send.incomming = true

    message_to_send
  end

  def self.duplicate_friends_message_for_sender(friends_message)
    senders_message = PrivateMessage.new
    senders_message.text = friends_message.text
    senders_message.user_id = friends_message.related_user_id
    senders_message.related_user_id = friends_message.user_id
    senders_message.incomming = false

    senders_message
  end
end
