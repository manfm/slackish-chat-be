class PrivateMessage < ActiveRecord::Base
  belongs_to :user

  validates :text, length: { minimum: 1 }
  validates :incomming, inclusion: { in: [true, false] }
  validates :user_id, :related_user_id, presence: true

  def self.for_user_from_user(to_user, from_user)
    where(user_id: to_user, related_user_id: from_user)
  end
end
