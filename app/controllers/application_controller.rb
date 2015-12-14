class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  respond_to :json

  def check_acl_rights!
      if params[:user_id].to_i != current_user.id
        render json: {
          errors: ["Authenticated user.id is not #{params[:user_id]}"]
        }, status: 401
        return
      end
  end
end
