class ChatController < WebsocketRails::BaseController
  def connected
    p 'user connected'
    send_message :new_message, text: 'hi', incomming: true
  end
end
