module Stick

  # = Unit Prefix
  #
  class Prefix

    # The system object to which this prefix belongs.
    attr :system

    # Long form of prefix, eg. "mega".
    attr :name

    # Short form of prefix, eg. "M".
    attr :symbol

    # Mulitplicative factor, eg 10e6.
    attr :factor

    #
    def initialize(system, name, symbol, factor)
      @system = system
      @name   = name
      @symbol = symbol
      @factor = factor #BigDecimal.new(factor.to_s)
    end

    #
    def method_missing(type)
      if system.types.key?(type)
        Measure.new(Unit.new(system.types[type], 1, self))
      else
        super
      end
    end

  end

end

