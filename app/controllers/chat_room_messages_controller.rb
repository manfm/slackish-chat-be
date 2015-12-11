class ChatRoomMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]

  def conversation
    from = params[:chatRoomId].to_i
    to = params[:userId].to_i
    @chat_room_messages = ChatRoomMessage.where("user_id = #{to} and chat_room_id = #{from}")

    render :index
  end

  def create
    text = params[:text].to_s
    user_id = params[:userId].to_i
    room_id = params[:chatRoomId].to_i

    messages_to_send = []
    chat_room = ChatRoom.find(room_id)
    chat_room.users.each do |chat_room_user|
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

    chat_room.last_message_at = DateTime.current
    chat_room.save

    my_message = ChatRoomMessage.new
    my_message.text = text
    my_message.user_id = user_id
    my_message.chat_room_id = room_id
    my_message.incomming = false

    @chat_room_message = my_message

    if my_message.save
      messages_to_send.each do |m|
        User.find(m.user_id).tokens.each do |client, _token|
          WebsocketRails[client].trigger('new_chat_room_message', m)
        end
      end

      current_user.tokens.each do |client, _value|
        WebsocketRails[client].trigger('new_chat_room_message', my_message) unless client == request.headers['client']
      end

      render :show, status: :created
    else
      render json: my_message.errors, status: :unprocessable_entity
    end
  end
end
