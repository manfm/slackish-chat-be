class NotificationService
  def self.push_to_user(user, message_key, data)
    user.tokens.each do |client, _value|
      WebsocketRails[client].trigger(message_key, data)
    end
  end
end
