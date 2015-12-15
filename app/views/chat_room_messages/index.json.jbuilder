json.array!(@chat_room_messages) do |chat_room_message|
  json.extract! chat_room_message, :id, :text, :user_id, :sender_id, :sender_name, :chat_room_id, :incomming, :created_at
end
