module Stick
module Units
module SI

 	# The second is the duration of 9,192,631,770 periods of the radiation
  # corresponding to the transition between the two hyperfine levels of
  # the ground state of the cesium 133 atom.

  class Second < BaseUnit

    SYMBOL = :s

    TYPE   = :time

    # AU conversion ratio
    FACTOR = AU::Ta

    # Convert to standard unit of measure.
    #
    def self.to_au(value, power)
      Measure.new(1/FACTOR, AU::Time => power)
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(AU::Time)
      raise ArgumentError unless power
      Measure.new(FACTOR * measure.value, self => power)
    end

    #
    def self.to_us(value, power)
      to_us_foot(value, power)
    end

    #
    def self.to_us_foot(value, power)
       
    end

    #
    def self.to_us_mile(value, power)
       
    end

  end

end
end
end

