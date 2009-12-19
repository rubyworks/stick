module Stick
module Units
module AU

  # = Anthropomorphic Plank Mass
  #
  # One plank mass is 2.17644(11) × 10^−8 kg. Applying
  # an anthropomorphic factor of 10^9, we arrive at 
  # 20.17644 kg per mA, or 0.049562757 mA/kg.
  #
  class Mass < Unit

    SYMBOL = :mA

    TYPE   = :mass

    # This is a base unit.
    def self.base? ; true ; end

  end

end
end
end

