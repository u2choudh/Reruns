class Series < ApplicationRecord
  has_many :episode, dependent: :destroy
end
