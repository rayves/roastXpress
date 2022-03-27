class Flavor < ApplicationRecord
  has_many :listings_flavors
  has_many :listings, through: :listings_flavors
end
