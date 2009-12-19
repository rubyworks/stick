module Stick

  # = Unit base class
  #
  # All other unit classes are a subclass of this.

  class Unit

    attr :value

    attr :power

    def initialize(value=1, power=1)
      @value = value
      @power = power
    end

    # I N F O R M A T I O N

    #

    def self.symbol ; self::SYMBOL ; end

    #

    def symbol ; self.class.symbol ; end

    #

    def self.type   ; self::TYPE   ; end

    #

    def type ; self.class.type ; end

    # A Unit is a base unit if it includes the Base module.

    def self.base?  ; self <= Base ; end

    #

    def base? ; self.class.base? ; end

    # Common term for unit in the plural. Defaults to
    # class basename downcased plus an 's'.

    def self.term
      name.split('::').last.downcase + 's'
    end

    #

    def term ; self.class.term ; end

    # Singular term defaults to class basename downcased.

    def self.single
      name.split('::').last.downcase
    end

    #

    def single ; self.class.single ; end

    #

    def self.system
      eval('::'+name.split('::')[0..-2].join('::'))
    end

    #

    def system ; self.class.system ; end

    # The #units method allows Unit to emulate a Measure.

    def units
      [self]
    end


    # C O N V E R S I O N S

    # Return a measure of this unit type.

    def self.^(power)
      self.class.new(new(power))
    end

    def universal
      to_au
    end

    def base
      raise "not implemented"
    end

    def standard
# TODO      Stick::Unit.system
    end

    def to_au
      raise "not implemented"
    end

    #

    def to_s
      s = symbol ? symbol.to_s : term.to_s
      if power != 1
        s = s + (power > 0 ? "^#{power}" : "#{power}")
      end
      "#{value} #{s}"
    end

    #

    alias_method :inspect, :to_s


    # C O M P A R I S O N S

    # sortable by term
    def <=>(other)
      term <=> other.term
    end

    # Compare value and units.
    #def eql?(other)
    #  return false unless self.class == other.class
    #  return false unless power == other.power
    #  return false unless multiple == other.multiple
    #  return true
    #end

    # Compare value and units.
    def ==(other)
      return false unless self.class == other.class
      return false unless power == other.power
      return false unless value == other.value
      return true
    end

    # Compare unit types.
    def ===(other)
      return false unless self.class == other.class
      return true
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, in less
    # or equal power, then +self+ is a *factor* of the +other+.

    def factor?(other)
      s =  self.universal.units.map{ |u| [u.class] * u.power }.flatten
      o = other.universal.units.map{ |u| [u.class] * u.power }.faltten
      (s - o).empty?
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, indifferent
    # of their power, then they are said to be *commensurate* units.

    def commensurate?(other)
      s =  self.universal.units.map{ |u| u.class }.uniq
      o = other.universal.units.map{ |u| u.class }.uniq
      (s - o).empty? && (o - s).empty?
    end

    # Reduce +self+ and the +other+ unit to their universal
    # measures, if the +other+ has all the same unit classes
    # in equal power as +self+, then they are said to be
    # *proportional* units, i.e. their ratio would produce
    # a unitless number.

    def proportional?(other)
      s =  self.universal.units.map{ |u| u.class }
      o = other.universal.units.map{ |u| u.class }
      (o - s).empty? && (s - o).empty?
    end

    # TODO: Better term?

    def systemic?(other)
      system = other.system
    end


    # O P E R A T I O N S

    #

    def normalize
      self.class.new(1, power)
    end

    #

    def +(other)
      case other
      when self.class
        raise "incompatible types" unless self.power == other.power
        self.class.new(value + other.value, power)
      else
        raise "incompatible types"
      end
    end

    def -(other)
      case other
      when self.class
        raise "incompatible types" unless self.power == other.power
        self.class.new(value - other.value, power)
      else
        raise "incompatible types"
      end
    end

    def *(other)
      case other
      when self.class
        self.class.new(value * other.value, power + other.power)
      else
        Measure.new(self, other)
      end
    end

    def /(other)
      case other
      when self.class
        self.class.new(value.to_f / other.value, power - other.power)
      else
        Measure.new(self, other**-1)
      end
    end

    def **(other)
      case other
      when Unit
        raise "incompatible types"
      else
        self.class.new(value**other, power*other)
      end
    end

    def ^(other)
      case other
      when Unit
        raise "incompatible types"
      else
        self.class.new(value, power*other)
      end
    end





    #


    #

    def self.inherited(base)
      return if base.basename == "Unit"
      register << base
    end

    #

    def self.register
      @@register ||= []
    end

  end

  #

  module Base
    def base ; self; end
  end    

end

