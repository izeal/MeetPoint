class Event < ApplicationRecord
  validates :title, presence: true, length: { maximum 255 }
  validates :datetime, presence: true
  validates :address, presence: true, length: { maximum 255 }
end
