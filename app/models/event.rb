class Event < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :photos, dependent: :destroy

  scope :asc, ->{
    order(datetime: :asc)
  }

  scope :past, ->{
    where('datetime < ?', Time.now).order(datetime: :desc)
  }

  scope :future, ->{
    where('datetime > ?', Time.now).order(datetime: :asc)
  }

  validates :title, presence: true, length: { maximum: 255 }
  validates :datetime, presence: true
  validates :address, presence: true, length: { maximum: 255 }
  validates :user, presence: true

  def visitors
    (subscribers + [user]).uniq
  end
end
