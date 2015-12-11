class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = User.find(params[:userId]).chat_rooms.order(last_message_at: :desc)
  end

  def create
    name = params[:name].to_s
    @chat_room = ChatRoom.new(name: name, last_message_at: DateTime.current)

    params[:users].each do |id|
      user = User.find(id)
      user.chat_rooms << @chat_room
      user.save
    end

    if @chat_room.save
      render :show, status: :created
    else
      render json: @chat_room.errors, status: :unprocessable_entity
  end
  end

  def destroy
    ChatRoom.find(params[:id]).destroy
    head :no_content
  end
end
