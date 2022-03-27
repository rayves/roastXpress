class Listing < ApplicationRecord
  belongs_to :grind_type
  belongs_to :user
  has_many :listings_flavors, dependent: :destroy
    # dependent: :destroy -> if listing is deleted then listings_feature related to that listing is deleted
  has_many :flavors, through: :listings_flavors

  # Coffee roast types represented by integers instead of having a set database as the number of roast types if unlikely to change.
  enum roast_type: {light: 1, medium: 2, medium_dark: 3, dark: 4}
  has_one_attached :picture
  
  # validation
  validates :name, :size, :price, :description, :quantity, :roast_type, :origin, presence: true
  validates :name, length: {minimum: 4}
  
end
