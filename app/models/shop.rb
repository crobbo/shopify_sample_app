class Shop < ApplicationRecord
  validates :store_url, presence: true, uniqueness: true
end
