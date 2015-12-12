class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = ChatRoom.for_user params[:userId]
  end

  def create
    @chat_room = ChatRoom.new(name: params[:name].to_s)

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
