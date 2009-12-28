require 'stick/conversion'

module Stick

  # = UnitType
  #
  # The UnitType defines the characteristics of a system unit,
  # including it's conversion table.

  class UnitType

    # Reference to system instance.
    attr :system

    # The name of the unit type. This should be the singular term.
    attr :name

    # Symbolic name.
    attr :symbol

    # Plural term.
    attr :plural

    # Type of quantity the unit measures.
    attr :quantity

    # Alternate terms by which this unit may be referred.
    attr :aliases

    # Conversion table.
    attr :conversions

    #
    def initialize(system, name, symbol, quantity, options={}) #:yield:
      @system   = system
      @name     = name.to_sym
      @symbol   = symbol.to_sym
      @quantity = quantity.to_sym

      @base    = options[:base]
      @prefix  = options[:prefix].nil? ? true : options[:prefix]

      @plural  = (options[:plural] || @name.to_s + 's').to_sym

      @aliases = [options[:alias], options[:aliases]].flatten.compact

      # TODO: Speed up by using a hash of system => conversion (?)
      @conversions = []
    end

    # Same as #name.

    alias_method :term, :name

    # Complete list of all terms by which this unit type may be referred.

    def terms
      ([name, symbol, plural] + aliases).uniq
    end

    # Plural term.
    #def plural
    #  @plural ||= (@name.to_s + 's').to_sym
    #end

    # Is this a base unit?

    def base?
      @base
    end

    # Is it a prefixable unit type?

    def prefix?
      @prefix
    end

    #

    alias_method :__inpsect__, :inspect

    #

    def to_s
      #keys = [name, symbol, *aliases]
      #"#<Type:#{keys.join(' ')}>"
      "#{system}:#{symbol || name}"
    end

    alias_method :inspect, :to_s

    #

    def conversion(conversion)
      case conversion
      when String
        conversion = parse(conversion)
      when UnitType
        conversion = Conversion.new(conversion => 1)
      when Conversion
        # ok
      when Numeric
        #conversions << conversion
      else
        raise TypeError
      end
      @conversions << conversion
      conversion
    end

    #

    def *(other)
      Conversion.new(:'*', self, other)
    end

    #

    def /(other)
      Conversion.new(:'/', self, other)
    end

    #

    def **(other)
      Conversion.new(:'**', self, other)
    end

    #

    def coerce(other)
      [self, other]
    end

    #
    def base #(measure)
      return Measure.new(Unit.new(self)) if base?
      conv = conversions.find{ |c| c.base? && c.system == system }
      conv.call #(measure)
    end

    #
    def universal
      return Measure.new(Unit.new(self)) if system == :au
      conv = conversions.find{ |c| c.system == :au }
      conv.call #(measure)
    end

    private

    def parse(conversion)
      system[conversion]
    end

  end

end

