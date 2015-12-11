json.array!(@private_messages) do |private_message|
  json.extract! private_message, :id, :text, :user_id, :related_user_id, :incomming, :created_at
end
