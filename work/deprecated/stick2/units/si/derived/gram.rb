module Stick
module Units
module SI

  # Simply 1,000th of a Kilogram.

  class Gram < Unit

    SYMBOL = :g

    TYPE   = :mass

    #
    def base
      Measure.new(0.001, Kilogram.new(power))
    end

    #
    def self.from_base(measure)
      power = measure.pure?(Kilogram)
      raise ArgumentError unless power
      Measure.new(1000 * measure.value, Gram.new(power))
    end

    #
    def to_au
      base.to_au
    end

    #
    def self.from_au(measure)
      from_base(Gram.from_au(measure))
    end

  end

end
end
end

