module Stick
module Units

  # = Naturalized Constants
  #
  #   c = 1      x (As / At)
  #   h = 1      x (At / As^2)
  #   G = 1/8 PI x (As^6 / At^5)

  constant :speed_of_light, :lightspeed, :symbol => :c
  constant :plancks_constant, :symbol => :h
  constant :gravitational_constant, :symbol => :G

  # Speed of Light (S / T)
  conversion :speed_of_light, :au do
    ratio(1, -1)
  end

  # Plancks Constant (T^2 / S)
  conversion :plancks_constant, :au do
    ratio(-1, 2)
  end

  # Gravitational Constant (S^6 / T^5)
  conversion :gravitational_constant, :au do
    ratio(6, -5) / 8 * PI
  end

  private

  #
  def ratio(space, time)
    Measure.new(As**-space, At**-time, 'au:space' => space, 'au:time' => time)
  end

end
end

#class Numeric
#  def speed_of_light
#    Stick::Units::AU::Constants.speed_of_light
#  end
#end

