module Stick
module Units
module AU

  # = Anthropomorphic Planck Charge
  #
  # Plancks charge is 1.875545870(47) × 10^−18 Coulombs
  # We apply an anthropomorphic factor of 10^18 to get
  # 1.875545870(47) Coulomb per qA, or 0.533178109 qA/C.
  #
  class Charge < Unit

    SYMBOL  = :qA

    TYPE    = :charge

    #AFACTOR = 10 ** 18

    # This is a base unit.
    def self.base? ; true ; end

  end

end
end
end
