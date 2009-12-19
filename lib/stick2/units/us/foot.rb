module Stick
module Units
module US

  #
  class Foot < Unit
    include Base

    SYMBOL = :ft

    TYPE   = :space

    #
    def self.term ; 'feet' ; end

    # TODO: direct conversion, instead of using SI
    def standard_measure #to_si
      #Measure.new(FACTOR, AU::Space.new(power))
      to_si.standard_measure
    end

    # TODO: direct conversion, instead of using SI
    def self.from_standard_mesaure(space)
      power = meters.pure?(AU::Space)
      raise ArgumentError unless power
      #Foot.measure(meters.value * 3.2808399, power)
      meters = SI::Meter.from_standard_measure(space)
      from_si(meters)
    end

    #
    def to_si
      #Measure.new(0.3048, SI::Meter.new(power))
      SI::Meter.measure(0.3048, power)
    end

    #
    def self.from_si(meters)
      power = meters.pure?(SI::Meter)
      raise ArgumentError unless power
      Foot.measure(meters.value * 3.2808399, power)
    end

  end

end
end
end

