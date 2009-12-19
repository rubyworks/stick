module Stick
module Units
module SI

  class Second < Unit
    include Base

    SYMBOL = :s
    TYPE   = :time

    #
    def to_au
      AU::Time.new(1/AU::Ta * value, power)
    end

    #
    def self.from_au(unit)
      raise ArgumentError, "requires AU::Time" unless AU::Time === unit
      new(AU::Ta * unit.value, unit.power)
    end

  end

end
end
end
