module Stick
module Units
module AU

  # = Universal Force
  #
  # F = M S / T^2

  class Force < Unit

    SYMBOL = 'F'

    TYPE   = :force

    #
    def base
      Measure.new(Mass.new(power), Space.new(power), Time.new(-power*2))
    end

    # FIXME: raise condition correct? Also get power better (how?)
    def self.from_base(measure)
      raise ArgumentError unless measure.proportional?(self.measure)
      value = measure.value
      power = measure.units.first.power
      Measure.new(value, new(power))
    end

  end

end
end
end

