class Series < ApplicationRecord
  has_many :episode, dependent: :destroy

  validates :title, presence: true
  validates :rating, presence: true
  validates :url, presence: true
  validates :seasons, presence: true
  validates :year, presence: true
  validates :image, presence: true
end
