class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.integer :size
      t.integer :price
      t.text :description
      t.integer :quantity
      t.string :origin
      t.integer :roast_type
      t.references :grind_type, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
