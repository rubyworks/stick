module Stick
module Units
module SI

 	# The second is the duration of 9,192,631,770 periods of the radiation
  # corresponding to the transition between the two hyperfine levels of
  # the ground state of the cesium 133 atom.

  class Second < Unit
    include Base

    SYMBOL = :s

    TYPE   = :time

    # Standard factor (see #standard_measure).
    FACTOR = 1/AU::Ta #1.47605194243369

    # Convert to standard unit of measure.
    #
    def to_au
      Measure.new(FACTOR, AU::Time.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.standard_measure
      power = measure.pure?(AU::Time)
      raise ArgumentError unless power
      Measure.new(measure.value * (FACTOR ** -1), new(power))
    end

  end

end
end
end
