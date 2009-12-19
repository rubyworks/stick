module Stick
module Units
module SI

  # = Naturalized Constants.
  #
  #   c = 1      x (As / At)
  #   h = 1      x (At / As^2)
  #   G = 1/8 PI x (As^6 / At^5)
  #
  module Constants

    PI = 3.14159265358979323846264338327950288

    # SI Metric conversion

    SPEED_OF_LIGHT          = 299792458.0     # m s-1
    PLANCKS_CONSTANT        = 6.62606896e-34  # 10−34 m2 kg / s
    GRAVITATIONAL_CONSTANT  = 6.67428e-11     # m3 kg-1 s-2

    # Speed of Light (m s-1)
    def speed_of_light
      Measure.new(SPEED_OF_LIGHT, Meter.new, Second.new(-1))
    end

    alias_method :c, :speed_of_light
    alias_method :lightspeed, :speed_of_light

    # Plancks Constant (J s -or- m2 kg s-1)
    def plancks_constant
      Measure.new(PLANCKS_CONSTANT, Joule.new, Second.new)
    end

    alias_method :h, :plancks_constant

    # Gravitational Constant (m3 kg-1 s-2)
    def gravitational_constant
      Measure.new(GRAVITATIONAL_CONSTANT, Meter.new(3), Kilogram.new(-1), Second.new(-2))
    end

  end

end
end
end

