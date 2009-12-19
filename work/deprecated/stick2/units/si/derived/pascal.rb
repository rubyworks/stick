module Stick
module Units
module SI

  class Pascal < Unit

    SYMBOL = :Pa

    TYPE   = :pressure

    #
    FACTOR = AU::Ma * AU::Sa**3 / AU::Ta

    # kg m^3 s-1

    def base
      Measure.new(Kilogram.new, Meter.new(3), Second.new(-1))
    end

    #

    def self.from_base(measure)
      mesaure = measure.base
      raise unless measure.proportional?(1.N) #FIXME
      Measure.new(measure.value, Newton.new)
    end

    #
    def to_au
      Measure.new(1/FACTOR, AU::Pressure.new(power))
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      #raise unles ...
      Measure.new(FACTOR * measure.value, new(measure.power))
    end

  end

end
end
end
