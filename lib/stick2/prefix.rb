require 'stick2/baseunit'

module Stick

  class Prefix

    attr :unit

    def initialize(unit)
      @unit = unit
    end

    #
    def symbol
      (self.class.symbol.to_s + unit.symbol).to_sym
    end

    #
    def term
      self.class.term + unit.term
    end

    #
    def self.single
      self.class.term + unit.single
    end

    #
    def to_lcm
      super * self.class.multiple
    end

    #
    def self.from_lcm(measure)
      super / self.class.prefix_multiple
    end

  end

end

