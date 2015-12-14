class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = ChatRoom.for_user params[:user_id]
  end

  def create
    # render json: 'required min 2 users', status: :unprocessable_entity if (users.size < 2)

    begin
      @chat_room = ChatRoomService.create_new_chat_room params[:name].to_s, params[:users].to_a
    rescue ActiveRecord::RecordInvalid => invalid
      validation_errors = invalid.record.errors
    end

    if !validation_errors
      render :show, status: :created
    else
      render json: validation_errors, status: :unprocessable_entity
  end
  end

  def destroy
    ChatRoom.find(params[:id]).destroy
    head :no_content
  end
end
