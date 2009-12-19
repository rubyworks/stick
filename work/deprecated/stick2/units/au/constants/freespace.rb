module Stick
module Units
module AU

  # Anthropomorphic Space Factor
  #As = 10**33  #10e34

  # Anthropomorphic Time Factor
  #At = 10**42  #10e45

  # = Naturalized Constants.
  #
  #   c = 1      x (As / At)
  #   h = 1      x (At / As^2)
  #   G = 1/8 PI x (As^6 / At^5)
  #
  module Constants
    extend self

    PI = 3.14159265358979323846264338327950288

    SPEED_OF_LIGHT   = 1
    PLANCKS_CONSTANT = 1
    GRAVITATIONAL_CONSTANT = 1/(8 * PI)

    #
    def self.ratio(space, time)
      Measure.new(As**-space, At**-time, Space.new(space), Time.new(time))
    end

    # Speed of Light (S / T)
    def speed_of_light
      Constants.ratio(1, -1)
    end

    alias_method :c, :speed_of_light
    alias_method :lightspeed, :speed_of_light

    # Plancks Constant (T^2 / S)
    def plancks_constant
      Constants.ratio(-1, 2)
    end

    alias_method :h, :plancks_constant

    # Gravitational Constant (S^6 / T^5)
    def gravitational_constant
      Constants.ratio(6, -5) / 8 * PI
    end

  end

end
end
end

class Numeric
  def speed_of_light
    Stick::Units::AU::Constants.speed_of_light
  end
end

