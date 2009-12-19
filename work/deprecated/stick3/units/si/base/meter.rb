module Stick
module Units
module SI

  class Meter < Unit
    include Base

    SYMBOL = :m
    TYPE   = :space

    #
    def to_au
      AU::Space.new((1/AU::Sa) * value, power)
    end

    #
    def self.from_au(unit)
      raise ArgumentError, "requires AU::Space" unless AU::Space === unit
      new(AU::Sa * unit.value, unit.power)
    end
  end

end
end
end
