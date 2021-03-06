class ChatController < WebsocketRails::BaseController
  before_action :authenticate_user!

  def initialize_session
    controller_store[:online] = []
  end

  def authorize_user_channel
    if user_signed_in? && current_user.tokens.key?(message[:channel])
      controller_store[:online][current_user.id] = current_user.id
      broadcast_message :user_online, current_user.id

      accept_channel current_user
    else
      deny_channel nil
    end
  end

  def connected
    send_message :users_online, controller_store[:online]
  end

  def disconnected
    controller_store[:online].delete(current_user.id)
    broadcast_message :user_offline, current_user.id
  end
end
