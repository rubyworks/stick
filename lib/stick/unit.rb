module Stick

  # Set or get the base system.
  def self.default(system=nil)
    @default = sysmtem if system
    @default
  end


  # = Base Unit
  #
  class Unit

    include Comparable

    # New unit has a +type+, +power+ and optionally a prefix.

    def initialize(type, power=1, prefix=nil)
      @type   = type
      @power  = power
      @prefix = prefix
    end

    # I N F O R M A T I O N

    # Unit type.
    attr :type

    # For working with squares, curbics, and so forth.
    attr :power

    #
    attr :prefix

    #

    def symbol
      type.symbol
    end

    #

    def term
      @term ||= (type.plural || type.name)
    end

    #

    def system
      type.system
    end

    #

    def kind
      type.kind
    end

    #

    def base?
      type.base?
    end


    # C O N V E R S I O N

=begin
    #

    def self.from_universal(measure)
      from_au(measure)
    end

    # Return a measure of this unit type.

    def self.^(power)
      Measure.new(new(power))
    end

    # Return a measure of this unit type.

    def self.[](power=1, value=1)
      Measure.new(value, new(power))
    end

    # Return a measure of this unit type.

    def self.measure(value=1, power=1)
      Measure.new(value, new(power))
    end
=end

    # Convert to a unit +Measure+.
    def measure
      Measure.new(1, self)
    end

    # Convert to a +Measure+.
    alias_method :to_m, :measure

    #
    def to_system(sys)
      return self if system == sys
      conv = type.conversions.find{ |c| c.system == sys }
      if conv
        conv.call #(self)
      else
        base.to_system(sys)
      end
    end

    # Convert to AU units of measure.

    def to_au
      return self if system == :au
      conv = type.conversions.find{ |c| c.system == :au }
      if conv
        conv.call #(self)
      else
        base.universal
      end
    end

    # Convert to universal system of measure.

    def universal
      to_au
    end

    # If the unit is a derived unit, convert it the base
    # units of it's system.

    def base
      if type.base?
        self
      else
        prefix ? type.base * prefix.factor : type.base
      end
    end

    # Convert to standard system of measure. The selected system can be
    # changed via the Stick.system method.
    #--
    # TODO: Improve register to make lookup faster.
    #++

    def standard
      # lookup system unit of same kind and is base unit
      conv = type.conversions.find do |c|
        c.base? &&
        c.kind == kind &&
        c.system == Stick.default
      end
      #unit = Unit.register.find do |u|
      #  u.base? &&
      #  u.type == self.type &&
      #  u.system == Stick.default
      #end
      # convert to univesral and from universal to standard
      #unit.from_universal(universal)
      conv.call(universal)
    end

    # Short-cut for #standard.

    alias_method :std, :standard

    #

    def unit ; self ; end

    # Display unit type.
    #def to_s
    #end

    # Show unit type in terms of it's symbol and power.

    def to_s
      if Prefix===prefix
        s = symbol ? "#{prefix.symbol}#{symbol}" : "#{prefix.name}#{term})"
      else
        s = symbol ? "#{symbol}" : "#{term}"
      end
      if power != 1
        s = s + (power > 0 ? "^#{power}" : "#{power}")
      end
      s
    end


    # O P E R A T I O N S

    #
    def invert
      self.class.new(type, -power, prefix)
    end

    #
    def **(number)
      self.class.new(type, power*number, prefix)
    end


    # C O M P A R I S O N S

    # sortable by term
    def <=>(other)
      term.to_s <=> other.term.to_s
    end

    # Compare value, units and prefix.
    def equal?(other)
      return false unless type == other.type
      return false unless power == other.power
      return false unless prefix == other.prefix
      return true
    end

    # Compare value and units.
    def ==(other)
      return false unless type == other.type
      return false unless power == other.power
      #return false unless prefix == other.prefix
      return true
    end

    # Compare unit types only.
    def ===(other)
      return false unless self.type == other.type
      return true
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, in less
    # or equal power, then +self+ is a *factor* of the +other+.

    def factor?(other)
      s =  self.base.unit.map{ |u| [u.type] * u.power }.flatten
      o = other.base.unit.map{ |u| [u.type] * u.power }.faltten
      (s - o).empty?
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, indifferent
    # of their power, then they are said to be *commensurate* units.

    def commensurate?(other)
      s =  self.base.unit.map{ |u| u.type }.uniq
      o = other.base.unit.map{ |u| u.type }.uniq
      (s - o).empty? && (o - s).empty?
    end

    # Reduce +self+ and the +other+ unit to their base measure.
    # If the +other+ has all the same unit types in equal power
    # as +self+, then they are said to be *proportional* units,
    # i.e. their ratio would produce a unitless number.

    def proportional?(other)
      s =  self.base.unit.map{ |u| u.type }
      o = other.base.unit.map{ |u| u.type }
      (o - s).empty? && (s - o).empty?
    end




    # C L A S S  M E T H O D S

    #
    #def self.symbol ; self::SYMBOL ; end

    #
    #def self.type   ; self::TYPE   ; end

    # A Unit is a base unit if it includes the Base module.
    #def self.base?  ; self <= Base ; end

    # Common term for unit in the plural. Defaults to
    # class basename downcased plus an 's'.
    #def self.term
    #  name.split('::').last.downcase + 's'
    #end

    # Singular term defaults to class basename
    # downcased.
    #def self.single
    #  name.split('::').last.downcase
    #end

    #
    #def self.system
    #  eval('::'+name.split('::')[0..-2].join('::'))
    #end

    # Convert from.
    #
    #def self.base(measure)
    #  __send__(Stick.system, measure)
    #end

    #
    #def self.inherited(base)
    #  return unless base.basename != "Unit"
    #  register << base
    #end

    #
    #def self.register
    #  @@register ||= []
    #end

    #def self.from_natural_measure(measure)
    #  raise "not implemented"
    #end

    #
    #def self.num(measure)
    #  measure = measure.num #measure.reduce
    #  #raise ArgumentError unless measure.commensurate?(nu)
    #  raise ArgumentError unless power = measure.base?(self)
    #  Measure.new(measure.value * (factor ** -1), new(power))
    #end

    #
    #def self.conversion(system, unit, factor)
    #  define_method("to_#{system}") do
    #    Measure.new(factor, unit.new(power))
    #  end
    #  (class << self; self; end).class_eval <<-END
    #    def #{system}(measure)
    #      measure = measure.to_#{system} #measure.reduce
    #      #raise ArgumentError unless measure.commensurate?(#{system})
    #      #power = measure.units.first.power
    #      raise ArgumentError unless power = measure.base?(self)
    #      Measure.new(measure.value * (factor ** -1), new(power))
    #    end
    #  END
    #end

  end

  #
  #module Unit::Base
  #
  #  def base?; true; end
  #
  #  #
  #  def base
  #    measure
  #  end
  #
  #end

end

