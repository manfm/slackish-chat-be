class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!

  def conversation
    from = params[:friendId].to_i
    to = params[:userId].to_i
    @private_messages = PrivateMessage.where("user_id = #{to} and related_user_id = #{from}")

    render :index
  end

  def create
    message_to_send = PrivateMessage.new
    message_to_send.text = params[:text]
    message_to_send.user_id = params[:friendId]
    message_to_send.related_user_id = params[:userId]
    message_to_send.incomming = true

    my_message = PrivateMessage.new
    my_message.text = params[:text]
    my_message.user_id = params[:userId]
    my_message.related_user_id = params[:friendId]
    my_message.incomming = false

    @private_message = my_message

    if message_to_send.save && my_message.save
      User.find(message_to_send.user_id).tokens.each do |client, _token|
        WebsocketRails[client].trigger('new_message', message_to_send)
      end
      current_user.tokens.each do |client, _value|
        WebsocketRails[client].trigger('new_message', my_message) unless client == request.headers['client']
      end

      render :show, status: :created
    else
      render json: message_to_send.errors, status: :unprocessable_entity
    end
  end
end
