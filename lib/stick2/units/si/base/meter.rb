module Stick
module Units
module SI

  # The meter is the length of the path travelled by light in vacuum
  # during a time interval of 1/299 792 458 of a second.

  class Meter < Unit
    include Base

    SYMBOL = :m

    TYPE   = :space

    # AU factor
    FACTOR = 1/AU::Sa #4.92357930643368

    # This is a base unit.
    #def self.base? ; true ; end

    #
    #def base_measure
    #  measure
    #end

    # Convert to standard unit of measure.
    #
    def to_au
      Measure.new(FACTOR, AU::Space.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.standard_measure
      power = measure.pure?(AU::Space)
      raise ArgumentError unless power
      Measure.new(measure.value * (FACTOR ** -1), new(power))
    end

=begin
    ##
    # Conversion to SI base unit measure and back.
    #
    # :method: to_base
    # :singleton-method: base(measure)
    #
    conversion :si, self, 1

    ##
    # Convert to US customery unit of feet.
    #
    # :method: to_us
    # :singleton-method: us(measure)
    #
    conversion :us, US::Foot
=end

  end

end
end
end
