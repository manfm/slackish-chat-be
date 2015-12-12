class ChatRoomMessagesController < ApplicationController
  before_action :authenticate_user!

  def conversation
    @chat_room_messages = ChatRoomMessage.for_user_in_room params[:userId], params[:chatRoomId]

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

      message_to_send = ChatRoomMessageService.create_message_for_friend text, chat_room_user.id, user_id, room_id
      message_to_send.save
      messages_to_send << message_to_send
    end

    chat_room.last_message_at = DateTime.current
    chat_room.save

    my_message = ChatRoomMessageService.duplicate_friends_message_for_sender(messages_to_send.first)

    @chat_room_message = my_message

    if my_message.save
      messages_to_send.each do |m|
        NotificationService.push_to_user User.find(m.user_id), 'new_chat_room_message', m
      end
      NotificationService.push_to_user current_user, 'new_chat_room_message', my_message

      render :show, status: :created
    else
      render json: my_message.errors, status: :unprocessable_entity
    end
  end
end
