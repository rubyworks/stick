module Stick
module Units
module AU

  # = Universal Current
  #
  # I = Q / t

  class Current < Unit

    SYMBOL = 'I'

    TYPE   = :current

    #
    def base
      Measure.new(Charge.new(power), Time.new(-power))
    end

    # FIXME: raise condition must be more strict
    def self.from_base(measure)
      raise ArgumentError unless measure.commensurate?(self.measure)
      value = measure.value
      power = measure.units.first.power
      Measure.new(value, new(power))
    end

  end

end
end
end
