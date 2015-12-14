class PrivateMessageService
  def self.create_new_message(text, recipient_id, sender_id)
    message_to_send = create_message_for_friend text, recipient_id, sender_id
    my_message = duplicate_friends_message_for_sender message_to_send

    ActiveRecord::Base.transaction do
      message_to_send.save!
      my_message.save!
    end

    NotificationService.push_to_user User.find(message_to_send.user_id), 'new_message', message_to_send
    NotificationService.push_to_user User.find(my_message.user_id), 'new_message', my_message

    my_message
  end

  def self.create_message_for_friend(text, recipient_id, sender_id)
    message_to_send = PrivateMessage.new
    message_to_send.text = text
    message_to_send.user_id = recipient_id
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
