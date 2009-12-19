module Stick
module Units
module SI

  class Hertz < Unit

    SYMBOL = :Hz

    #
    def base
      Second.new(-power)
    end

    #
    def self.from_base(measure)
      measure = measure.base
      power = measure.pure?(Second)
      raise ArgumentError unless power
      measure.invert  # or, reciprocal (?)
    end

    #
    def to_au
      base.to_au
    end

    #
    def self.from_au(measure)
      from_base(Meter.from_au(measure))
    end

  end

end
end
end
