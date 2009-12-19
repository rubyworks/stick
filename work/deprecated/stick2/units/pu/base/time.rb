module Stick
module Units
module AU

  # = Anthropomorphic Plank Time
  #
  # One plank time is 5.39124(27) × 10^−44 seconds.
  # Applying an anthropomorphic factor of 10^45,
  # we get 50.39124 seconds per tA, or 0.019844719 tA/s.
  #
  class Time < Unit

    SYMBOL = :tA

    TYPE   = :time

    # This is a base unit.
    def self.base? ; true ; end

  end

end
end
end
