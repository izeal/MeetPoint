class Subscription < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true
  validates :user_name, presence: true, unless: -> { user }
  validates :user_email,
            presence: true,
            format: VALID_EMAIL_REGEX,
            uniqueness: { scope: :event_id },
            unless: -> { user }

  validates :user, uniqueness: { scope: :event_id }, if: -> { user }

  def user_name
    user ? user.name : super
  end

  def user_email
    user ? user.email : super
  end
end
