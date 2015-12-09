json.array!(@chat_rooms) do |chat_room|
  json.extract! chat_room, :id, :name, :last_message_at
  json.url chat_room_url(chat_room, format: :json)
end
