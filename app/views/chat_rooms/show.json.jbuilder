json.extract! @chat_room, :id, :name, :last_message_at, :created_at
json.users chat_room.users, :id, :uid, :email
