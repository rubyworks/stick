module Stick
module Units
module AU

  # = Anthropomorphic Planck Length
  #
  # One plank length is 1.616252 x 10^-35 meters.
  # Applying an anthropomorphic factor of 10^36
  # we get 10.616252 meters per mA, or 0.094195202 lA/m.
  #
  class Length < Unit

    SYMBOL = :lA

    TYPE   = :length

    # This is a base unit.
    def self.base? ; true ; end

  end

end
end
end
