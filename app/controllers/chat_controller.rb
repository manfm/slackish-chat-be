class ChatController < WebsocketRails::BaseController
  before_action :authenticate_user!

  def initialize_session
    controller_store[:event_count] = 0
  end

  # def get_channel_key
  #   if user_signed_in?
  #     key = current_user.channel_key
  #     WebsocketRails[key].make_private
  #     send_message :key, key, namespace: :user
  #   else
  #     send_message :key, nil, namespace: :user
  #   end
  # end

  def authorize_user_channel
    if user_signed_in? && current_user.tokens.key?(message[:channel])
      # if current_user.seen == 1
      #   WebsocketRails[:online_users].trigger "seen", current_user
      # end
      accept_channel current_user
    else
      deny_channel nil
    end
  end

  def connected
    controller_store[:event_count] += 1
    broadcast_message :new_message, text: "hi: #{controller_store[:event_count]}", incomming: true
  end

  def disconnected
    # p message
    controller_store[:event_count] -= 1
    broadcast_message :new_message, text: "hi: #{controller_store[:event_count]}", incomming: true
  end
end
