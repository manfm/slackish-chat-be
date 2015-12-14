class ChatRoomMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_acl_rights!

  def conversation
    @chat_room_messages = ChatRoomMessage.for_user_in_room params[:user_id], params[:chat_room_id]

    render :index
  end

  def create
    begin
      @chat_room_message = ChatRoomMessageService.create_new_message params[:text].to_s, params[:user_id].to_i, params[:chat_room_id].to_i
    rescue ActiveRecord::RecordInvalid => invalid
      validation_errors = invalid.record.errors
    end

    if !validation_errors
      render :show, status: :created
    else
      render json: validation_errors, status: :unprocessable_entity
    end
  end
end
