module Stick
module Units
module SI

  # The candela is the luminous intensity, in a given direction,
  # of a source# that emits monochromatic radiation of frequency
  # 540 x 1012 hertz and that has a radiant intensity in that
  # direction of 1/683 watt per steradian.

  class Candela < Unit
    include Base

    SYMBOL = :cd

    TYPE   = '?' # TODO

    # AU conversion ratio
    FACTOR = 0.0618715088 # FIXME

    # Convert to standard unit of measure.
    #
    def to_au
      Measure.new(FACTOR)
    end

    #
    def self.from_au(measure)
      measure = measure.natural_measure
      raise ArgumentError unless power = measure.pure?()
      Measure.new(measure.value * (FACTOR ** -1), new(power))
    end

  end

end
end
end
