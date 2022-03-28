module ListingsHelper
    def format_roast_type(roast)
        roast.split("_").map {|word| word.capitalize}.join("/")
    end

    def quantity_selection
        quantitys = []
        i = 0
        @listing.quantity.times do
            quantitys << 1 + i
            i += 1
        end
        return quantitys
    end
end

