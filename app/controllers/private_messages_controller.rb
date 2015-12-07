class PrivateMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]

  def conversation
    from = params[:friendId]
    to = params[:userId]

    render json: PrivateMessage.where("user_id = #{to} and related_user_id = #{from}")
  end

  def create
    message_to_send = PrivateMessage.new
    message_to_send.text = params[:text]
    message_to_send.user_id = params[:friendId]
    message_to_send.related_user_id = params[:userId]
    message_to_send.incomming = true

    @private_message = message_to_send

    my_message = PrivateMessage.new
    my_message.text = params[:text]
    my_message.user_id = params[:userId]
    my_message.related_user_id = params[:friendId]
    my_message.incomming = false

    respond_to do |format|
      if message_to_send.save && my_message.save
        User.find(message_to_send.user_id).tokens.each do |client,token|
          WebsocketRails[client].trigger('new_message', message_to_send)
        end
        current_user.tokens.each do |client,value|
          WebsocketRails[client].trigger('new_message', my_message) unless (client == request.headers['client'])
        end

        format.html { redirect_to message_to_send, notice: 'Private message was successfully created.' }
        format.json { render :show, status: :created, location: message_to_send }
      else
        format.html { render :new }
        format.json { render json: message_to_send.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_private_message
  #   message_to_send = PrivateMessage.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def private_message_params
    params[:private_message]
  end
end
