# REPL
require './building'
require 'fancy_gets'
include FancyGets

loop do
  cmd = gets_list(["Add Building",
                   "Add Apartment",
                   "Remove Building",
                   "Remove Apartment",
                   "Update Building",
                   "Update Apartment",
                   "List Buildings and Apartments",
                   "Pry",
                   "Quit"])
  case cmd
  when "Add Building"
    puts "Name:"
    name = gets.chomp
    puts "Postcode:"
    postcode = gets.chomp
    building = Building.new(name)
    building.update(postcode: postcode)
    puts "BUILT!"
  when "Add Apartment"
    building = gets_list(Building.all)
    puts "Number:"
    number = gets.chomp
    building.add_apartment(number)
    puts "Added!!!"
  when "Remove Building"
    building = gets_list(Building.all)
    building.destroy
    puts "DESTROYED!"
  when "Remove Apartment"
    building = gets_list(Building.all)
    apartment = gets_list(building.apartments)
    apartment.destroy
    puts "DESTROYED!"
  when "List Buildings and Apartments"
    puts "================="
    Building.all.each do |building|
      puts building.to_s
      building.apartments.each do |apartment|
        puts "  #{apartment.to_s}"
      end
    end
    puts "================="
  when "Pry"
    binding.pry
  when "Quit"
    break
  end
end

puts "BYE!!!!"
