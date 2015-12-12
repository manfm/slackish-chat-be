class PrivateMessage < ActiveRecord::Base
  belongs_to :user

  def self.for_user_from_user(to_user, from_user)
    where(user_id: to_user, related_user_id: from_user)
  end
end
