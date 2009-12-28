module Stick
module Units
module UK

  #
  class Foot < Unit

    SYMBOL = :ft

    #
    def self.term
      'feet'
    end

    #
    def to_lcm #to_si
      Measure.new(0.3048, SI::Meter.new(power))
    end

    #
    #def from_lcm(meters)
    #  meters * 3.2808399 # feet
    #end

    #
    #def system
    #  [:us, :uk]
    #end

  end

end
end
end

