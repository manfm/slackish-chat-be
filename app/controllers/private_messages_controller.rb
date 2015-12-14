class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!

  def conversation
    @private_messages = PrivateMessage.for_user_from_user params[:user_id], params[:friend_id]

    render :index
  end

  def create
    begin
      @private_message = PrivateMessageService.create_new_message params[:text].to_s, params[:friend_id].to_i, params[:user_id].to_i
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
