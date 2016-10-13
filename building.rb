require 'pry'
require 'yaml'
require './apartment'

class Building
  attr_accessor :apartments, :name, :floors, :postcode

  @@buildings = []

  def add_apartment(number)
    apartment = Apartment.new(self, number)
    self.apartments << apartment
  end

  def to_s
    "#{self.name}, #{self.postcode}"
  end


  # C
  def initialize(name, floors = 1, postcode = nil)
    self.apartments = []
    self.name = name
    self.floors = floors
    self.postcode = postcode
    @@buildings << self
  end

  # Class method
  def self.count
    @@buildings.count
  end

  # R - read
  # All the buildings
  def self.all
    @@buildings
  end
  # All that match params
  def self.where(params)
    results = []
    @@buildings.each do |building|
      is_match = true
      params.each do |k,v|
        if building.send(k) != v
          is_match = false
        end
      end
      results << building if is_match
    end
    results
  end
  # The first that matches params
  def self.find_by(params)
    self.where(params).first
  end

  # U - update
  def update(params)
    params.each do |k,v|
      self.send(k.to_s + "=", v)
    end
    self
  end

  # D
  def destroy
    # Remove it from our array
    @@buildings.delete_at(@@buildings.index(self))
    self
  end

  # Save all buildings
  def self.save_all
    file = File.open("buildings.yml", "w")
    file.write(self.all.to_yaml)
    file.close
  end

  # Make this thing persist
  # Grab existing buildings when the class gets loaded
  if File.exist? "buildings.yml"
    @@buildings = YAML.load_file("buildings.yml")
  end

  if Apartment.count == 0 
    Apartment.load_all
    # Still didn't get anything?  Then reverse-engineer what it should be
    if Apartment.count == 0
      all_apartments = []
      self.all.each do |building|
        all_apartments += building.apartments
      end
      Apartment.class_variable_set(:@@apartments, all_apartments)
    end
  end 

  # Set up a finalizer to save buildings when we bail
  ObjectSpace.define_finalizer(self, proc { self.save_all })
end
