class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!

  def conversation
    @private_messages = PrivateMessage.for_user_from_user params[:userId], params[:friendId]

    render :index
  end

  def create
    message_to_send = PrivateMessageService.create_message_for_friend params[:text], params[:friendId], params[:userId]
    my_message = PrivateMessageService.duplicate_friends_message_for_sender message_to_send
    @private_message = my_message

    if message_to_send.save && my_message.save
      NotificationService.push_to_user User.find(message_to_send.user_id), 'new_message', message_to_send
      NotificationService.push_to_user current_user, 'new_message', my_message

      render :show, status: :created
    else
      render json: message_to_send.errors, status: :unprocessable_entity
    end
  end
end
