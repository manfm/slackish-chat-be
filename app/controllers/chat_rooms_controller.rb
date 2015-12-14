class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_acl_rights!

  def index
    @chat_rooms = ChatRoom.for_user params[:user_id]
  end

  def create
    if params[:users].to_a.size < 2
      render json: {
        users: ["Please select at least 2 users for chat room"]
      }, status: :unprocessable_entity
      return
    end

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
