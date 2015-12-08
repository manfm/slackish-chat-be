WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  subscribe :client_connected, 'Chat#connected'
  # subscribe :client_disconnected, 'Chat#disconnected'
  # subscribe :connection_closed, 'Chat#disconnected'
  namespace :websocket_rails do
    subscribe :subscribe_private, 'Chat#authorize_user_channel'
  end

  # namespace :user do
  #   subscribe :get_channel_key, 'Chat#get_channel_key'
  # end
end
