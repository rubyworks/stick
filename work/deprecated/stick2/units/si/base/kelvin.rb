module Stick
module Units
module SI

  # The kelvin, unit of thermodynamic temperature, is the fraction 1/273.16
  # of the thermodynamic temperature of the triple point of water.

  class Klevin < Unit
    include Base

    SYMBOL = :K

    TYPE   = :temperature

    # AU conversion ratio
    FACTOR = AU::Ha

    # Convert to universal unit of measure.
    #
    def to_au
      Measure.new(1/FACTOR, AU::Heat.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(AU::Heat)
      raise ArgumentError unless power
      Measure.new(FACTOR * measure.value, new(power))
    end

  end

end
end
end
