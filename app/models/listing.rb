class Listing < ApplicationRecord
  belongs_to :grind_type
  belongs_to :user

  # Coffee roast types represented by integers instead of having a set database as the number of roast types if unlikely to change.
  enum roast_type: {light: 1, medium: 2, medium_dark: 3, dark: 4}
  has_one_attached :picture
  
end
