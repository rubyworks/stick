module Stick
module Units
module SI

  class Newton < Unit

    SYMBOL = :N

    TYPE   = :force

    #
    def base
      Measure.new(value, Meter.new(1, power), Kilogram.new(1,power), Second.new(1,-power))
    end

    #
    def to_au
      #AU::Space.new((1/AU::As) * value, power)
    end

    #
    def from_au(unit)
      #raise ArgumentError, "requires AU::Space" unless AU::Space === unit
      #new(AU::As * unit.value, unit.power)
    end

  end

end
end
end
