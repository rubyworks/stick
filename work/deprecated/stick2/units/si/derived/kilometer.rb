module Stick
module Units
module SI

  class Kilometer < Unit

    SYMBOL = :km

    TYPE   = :space

    #
    def base
      Measure.new(1000, Meter.new(power))
    end

    #
    def self.from_base(measure)
      measure = measure.base
      power = measure.pure?(Meter)
      raise ArgumentError unless power
      Measure.new(measure.value, 0.001, Kilometer.new(power))
    end

    #
    def to_au
      base.to_au
    end

    #
    def self.from_au(measure)
      from_base(Meter.from_au(measure))
      #Measure.new(meters.value / 1000, Kilometer.new(m.units.first.power))
      #measure = measure.to_au
      #raise ArgumentError unless power = measure.base?(AU::Space)
      #Measure.new(measure.value * (Meter::FACTOR ** -1) / 1000, Kilometer.new(power))
    end

  end

end
end
end
