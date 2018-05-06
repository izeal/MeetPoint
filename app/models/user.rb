class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation { email.downcase! }
  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :photos, dependent: :destroy

  validates :name, presence: true, length: { maximum: 35 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            uniqueness: true,
            format: { with: VALID_EMAIL_REGEX }

  after_commit :link_subscriptions, on: :create

  mount_uploader :avatar, AvatarUploader

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).
      update_all(user_id: self.id)
  end
end
