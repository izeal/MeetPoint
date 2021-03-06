class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true
  validates :user, presence: true
  validates :photo, presence: true

  mount_uploader :photo, PhotoUploader

  scope :persisted, -> { where.not(id: nil) }
end
