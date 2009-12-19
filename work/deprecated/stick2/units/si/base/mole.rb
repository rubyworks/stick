module Stick
module Units
module SI

  # 1. The mole is the amount of substance of a system which contains
  # as many elementary entities as there are atoms in 0.012 kilogram
  # of carbon 12; its symbol is "mol."
  #
  # 2. When the mole is used, the elementary entities must be specified
  # and may be atoms, molecules, ions, electrons, other particles,
  # or specified groups of such particles. 
  #
  # 1 mol consists of 6.0221415×10^23 atoms.

  class Mole < Unit
    include Base

    SYMBOL = :mole

    TYPE   = :number

    # Convert to standard unit of measure.
    #
    # A mole is just a number. Therefore technically it is a unitless
    # constant rather than a unit of measure. Since there is no equivalent
    # in Plank units, the mol serves as it's own universal unit.
    #
    def to_au
      Measure.new(self)
    end

    #
    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(self)
      raise ArgumentError unless power
      Measure.new(measure.value, new(power))
    end

  end

end
end
end

