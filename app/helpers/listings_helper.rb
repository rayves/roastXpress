module ListingsHelper
    def format_roast_type(roast)
        roast.split("_").map {|word| word.capitalize}.join("/")
    end
end
