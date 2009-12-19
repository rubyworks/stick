require 'stick2/conversion'

module Stick
module Units

  #

  class Type

    attr :system

    attr :name

    attr :term

    attr :symbol

    attr :kind

    attr :aliases

    attr :conversions

    #

    def initialize(system, name, symbol, kind, options={}) #:yield:
      @system  = system
      @name    = name.to_sym
      @symbol  = symbol
      @kind    = kind
      @base    = options[:base]

      term    = options[:plural]  || name.to_s + 's'
      aliases = options[:aliases] || []

      @term    = term.to_sym
      @aliases = aliases.compact.flatten

      # TODO: Speed up by using a hash of system => conversion (?)
      @conversions = []
    end

    # DEPRECATE: use term instead
    def plural
      term
    end

    #

    def base?
      @base
    end

    alias_method :__inpsect__, :inspect

    #

    def to_s
      #keys = [name, symbol, *aliases]
      #"#<Type:#{keys.join(' ')}>"
      (symbol || name).to_s
    end

    alias_method :inspect, :to_s

    #

    def conversion(conversion)
      case conversion
      when Type
        conversion = Conversion.new(conversion => 1)
      when Conversion
        # ok
      else
        raise TypeError
      end
      @conversions << conversion
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
      return self if base?
      conv = conversions.find{ |c| c.base? && c.system == system }
      conv.call #(measure)
    end

    #
    def universal
      return self if system == :au
      conv = conversions.find{ |c| c.system == :au }
      conv.call #(measure)
    end

  end

end
end

