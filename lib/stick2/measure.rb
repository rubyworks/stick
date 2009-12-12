module Stick

  # A measure has a value and a unit.
  class Measure < Numeric

    #
    attr :value

    #
    attr :unit

    # A measure has a value and a unit.
    def initialize(value, unit)
      @value = value
      @unit  = unit
    end

    #
    def to_lcm
      Measure.new(value, unit.to_lcm)
    end

    #
    def normalize
      v = value
      u = []
      unit.each do |b|
        v = v * b.multiple
        u << b.class.new(b.power)
      end
      Measure.new(v, Unit.new(u))
      #@value = v
      #@unit  = Unit.new(u)
      #self
    end

    #
    def invert
      Measure.new(value, unit.invert)
    end

    #
    def +(other)
      if unit == other.unit
        Measure.new(value + other.value, unit)
      else
        a = to_lcm.normalize
        b = other.to_lcm.normalize
        raise "incompatible units" if a.unit != b.unit
        a + b
      end
    end

    #
    def -(other)
      if unit == other.unit
        Measure.new(value - other.value, unit)
      else
        a = to_lcm.normalize
        b = other.to_lcm.normalize
        raise "incompatible units" if a.unit != b.unit
        a - b
      end
    end

    #
    def *(other)
      if unit == other.unit
        Measure.new(value * other.value, unit)
      else
        a = to_lcm.normalize
        b = other.to_lcm.normalize
        if a.unit == b.unit
          a * b
        else
          Measure.new(value * other.value, Unit.new(unit.bases, other.unit.bases))
        end
      end
    end

    #
    def /(other)
      if unit == other.unit
        Measure.new(value.to_f / other.value, unit)
      else
        a = to_lcm.normalize
        b = other.to_lcm.normalize
        if a.unit == b.unit
          a / b
        else
          Measure.new(value / other.value, Unit.new(unit.bases, other.invert.unit.bases))
        end
      end
    end

    def to_s
      "#{value} #{unit}"
    end

    alias_method :inspect, :to_s

  end

end

