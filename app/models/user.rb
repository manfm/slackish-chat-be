class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  before_save -> { skip_confirmation! }

  has_many :private_messages
  has_and_belongs_to_many :chat_rooms
end
