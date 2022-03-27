# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clean database and reset id sequence to 1
ListingsFlavor.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!("listings_flavors")
Listing.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!("listings")
User.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!("users")


grind_types = ["extra fine", "fine", "medium", "coarse", "extra coarse"]


if GrindType.count == 0
    grind_types.each do |grind|
        GrindType.create(name: grind)
        puts "Generated Grind Type #{grind}"
    end
end

if Flavor.count == 0
    15.times do |i|
        Flavor.create(
            name: Faker::Dessert.flavor
        )
        puts "Generated flavor no. #{i+1}"
    end
end

if User.count == 0
    sample_user = User.create(
        email: "test@sample.com",
        password: "password1"
    )
    puts "sample_user generated"
end

if Listing.count == 0
    8.times do |i|
        flavors = Array.new(rand(1..15)) { rand(1...15) }
        Listing.create(
            name: Faker::Coffee.blend_name,
            size: 250,
            price: rand(1..500),
            description: Faker::Coffee.notes,
            quantity: 10,
            origin: Faker::Address.country,
            roast_type: rand(1..4),
            grind_type: GrindType.order(Arel.sql('RANDOM()')).first,
            user_id: sample_user.id,
            flavor_ids: flavors
        )
        puts "sample_user created listing no. #{i+1}"
    end
end