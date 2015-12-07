class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    WebsocketRails['abc'].trigger('new_message', text: 'hi', incomming: true)
    @users = User.all
  end

  def show
  end
end
