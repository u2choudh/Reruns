class Episode < ApplicationRecord
  belongs_to :series

  validates :title, presence: true
  validates :description, presence: true
  validates :epnum, presence: true
  validates :rating, presence: true
  validates :season, presence: true
  validates :series_id, presence: true
end
