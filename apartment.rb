class Apartment
  attr_accessor :building, :number

  @@apartments = []

  def to_s
    "#{self.number}"
  end


  # C
  # Defaults the apartment number to nil
  def initialize(building, number = nil)
    self.building = building
    self.number = number
    @@apartments << self
  end

  # Class method
  def self.count
    @@apartments.count
  end

  # R - read
  # All the apartments
  def self.all
    @@apartments
  end
  # All that match params
  def self.where(params)
    results = []
    @@apartments.each do |apartment|
      is_match = true
      params.each do |k,v|
        if apartment.send(k) != v
          is_match = false
        end
      end
      results << apartment if is_match
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
    # If we're in a building, remove ourselves from that
    # building's apartments array
    if self.building
      index = self.building.apartments.index(self)
      self.building.apartments.delete_at(index)
    end
    # Remove it from our array
    @@apartments.delete_at(@@apartments.index(self))
    self
  end

  # Make this thing persist
  # Save all apartments
  def self.save_all
    file = File.open("apartments.yml", "w")
    file.write(self.all.to_yaml)
    file.close
  end

  def self.load_all
    if File.exists?("apartments.yml")
      @@apartments = YAML.load_file("apartments.yml")
      @@apartments = [] if @@apartments == false
    end
  end

  # Grab existing apartments when the class gets loaded
  if defined?(Building) == 'constant'
    self.load_all
  end

  # Set up a finalizer to save apartments when we bail
  ObjectSpace.define_finalizer(self, proc { self.save_all })
end
