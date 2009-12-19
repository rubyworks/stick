module Stick
module Units
module SI

  # The kilogram is the unit of mass; it is equal to the mass
  # of the international prototype of the kilogram.

  class Kilogram < Unit
    include Base

    SYMBOL = :kg

    TYPE   = :mass

    # AU conversion ratio
    FACTOR = AU::Ma

    # Convert to univeral unit of measure.
    #
    def to_au
      Measure.new(1/FACTOR, AU::Mass.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(AU::Mass)
      raise ArgumentError unless power
      Measure.new(FACTOR * measure.value, new(power))
    end

  end

end
end
end

