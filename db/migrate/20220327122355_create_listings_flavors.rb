class CreateListingsFlavors < ActiveRecord::Migration[7.0]
  def change
    create_table :listings_flavors do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :flavor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
