module Stick
module Units

  #
  class Foot < BaseUnit

    #
    def symbol
      :ft
    end

    #
    def term
      'feet'
    end

    #
    def singular
      'foot'
    end

    #
    def to_lcm
      Meter.new(power, 0.3048)
    end

    #
    #def from_lcm(meters)
    #  meters * 3.2808399 # feet
    #end

    #
    def system
      [:us, :uk]
    end

  end

end
end

