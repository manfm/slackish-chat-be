class ChatRoomMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]

  def conversation
    from = params[:chatRoomId]
    to = params[:userId]

    render json: ChatRoomMessage.where("user_id = #{to} and chat_room_id = #{from}")
  end

  def new_message
    text = params[:text].to_s
    user_id = params[:userId].to_i
    room_id = params[:chatRoomId].to_i

    messages_to_send = []
    ChatRoom.find(room_id).users.each do |chat_room_user|
      next if chat_room_user.id == user_id

      message_to_send = ChatRoomMessage.new
      message_to_send.text = text
      message_to_send.user_id = chat_room_user.id
      message_to_send.chat_room_id = room_id
      message_to_send.sender_id = user_id
      message_to_send.incomming = true
      message_to_send.save

      messages_to_send << message_to_send
    end

    messages_to_send.each do |m|
      User.find(m.user_id).tokens.each do |client, _token|
        WebsocketRails[client].trigger('new_chat_room_message', m)
      end
    end

    my_message = ChatRoomMessage.new
    my_message.text = text
    my_message.user_id = user_id
    my_message.chat_room_id = room_id
    my_message.incomming = false
    my_message.save

    current_user.tokens.each do |client, _value|
      WebsocketRails[client].trigger('new_chat_room_message', my_message) unless client == request.headers['client']
    end

    render json: {status: 'created'}
  end

  private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_private_message
  #   message_to_send = PrivateMessage.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def private_message_params
    params[:private_message]
  end
end
