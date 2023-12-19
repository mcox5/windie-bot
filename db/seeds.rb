# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.
#
# For example:
#
# Country.create(name: "Chile") # BAD
# Country.find_or_create_by(name: "Chile") # GOOD
#

# Create Sports
puts "Creating sports..."
Sport.find_or_create_by(sport_name: "surf")
Sport.find_or_create_by(sport_name: "kitesurf")
Sport.find_or_create_by(sport_name: "pesca")

# Create Spots
puts "Creating spots..."
WindguruLocations::CODE_LOCATIONS.each do |location_name, code|
  Spot.find_or_create_by(name: location_name, windguru_code: code.to_i)
end
