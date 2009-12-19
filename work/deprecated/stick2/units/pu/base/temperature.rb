module Stick
module Units
module AU

  # = Anthropomorphic Plank Temperature
  #
  # One plank temperature is 1.416785(71) × 10^32 Kelvin.
  # We apply an anthropomorphic factor of 10^-33 to arrive at
  # 0.1416785 K per thA, or 7.058233959 thA/K.

  class Temperature < Unit

    # Natural thermal unit symbol.
    SYMBOL  = :thA

    TYPE    = :temperature

    #AFACTOR = 10 ** -33

    # This is a base unit.
    def self.base? ; true ; end

  end

end
end
end
