# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

grind_types = ["extra fine", "fine", "medium", "coarse", "extra coarse"]

roast_types = ["light", "medium", "medium/dark", "dark"]

if GrindType.count == 0
    grind_types.each do |grind|
        GrindType.create(name: grind)
        puts "Generated Grind Type #{grind}"
    end
end

if RoastType.count == 0
    roast_types.each do |roast|
        RoastType.create(name: roast)
        puts "Generated Roast Type #{roast}"
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