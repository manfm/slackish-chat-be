json.array!(@users) do |user|
  json.extract! user, :id, :uid, :email, :created_at
end
