class Event < ApplicationRecord
  belongs_to :user
  has_many :comments

  scope :desc, ->{
    order("events.datetime ASC")
  }

  validates :title, presence: true, length: { maximum: 255 }
  validates :datetime, presence: true
  validates :address, presence: true, length: { maximum: 255 }
  validates :user, presence: true
end
