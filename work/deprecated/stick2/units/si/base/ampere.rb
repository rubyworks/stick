module Stick
module Units
module SI

  # The ampere is that constant current which, if maintained in two straight
  # parallel conductors of infinite length, of negligible circular cross-section,
  # and placed 1 meter apart in vacuum, would produce between these conductors
  # a force equal to 2 x 10-7 newton per meter of length.

  class Ampere < Unit
    include Base

    SYMBOL = :A

    TYPE   = :current

    # AU conversion ratio
    FACTOR = AU::Qa / AU::Ta

    # Convert to standard units of measure.
    #
    def to_au #universal
      Measure.new(1/FACTOR, AU::Current.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(AU::Current)
      raise ArgumentError unless power
      Measure.new(FACTOR * measure.value, new(power))
    end

  end

end
end
end
