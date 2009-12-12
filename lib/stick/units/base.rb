# Title:
#
#    Units
#
# Summary:
#
#   SI Units system, integrated into Ruby's method call system.
#
# Copyright:
#
#   Copyright (c) 2005 Peter Vanbroekhoven, Thomas Sawyer
#
# License:
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# Created:
#
#   2005.08.01
#
# Authors:
#
#   - Peter Vanbroekhoven
#   - Thomas Sawyer

require 'rbconfig'
require 'stick/units/loaders'

class Exception

  def clean_backtrace(regex)
    regex = /^#{::Regexp.escape(__FILE__)}:\d+:in `#{::Regexp.escape(regex)}'$/ if regex.is_a? ::String
    set_backtrace(backtrace.reject { |a| regex =~ a })
    self
  end

  def self.with_clean_backtrace(regex)
    begin
      yield
    rescue ::Exception
      $!.clean_backtrace(regex).clean_backtrace("with_clean_backtrace") if not $DEBUG
      raise
    end
  end

end

module Stick

# The namespace for all unit related classes. Mixing this in has the additional effect
# of making Units.with_unit_converter available without the <code>Units.</code> prefix,
# as well as the shortcuts for creating Units (see Units#method_missing).
#
#--
#   http://en.wikipedia.org/wiki/Celsius_scale
#
#   degrees_Celsius vs Celsius_degrees
#   Kelvin
#
#   Kelvin  Celsius   Fahrenheit  Rankine   Delisle   Newton  Réaumur   Rømer
#
#   K       C         F           R         D         N       R         R
#
#   http://en.wikipedia.org/wiki/Conversion_of_units
#++

module Units

  def method_missing(m, *args, &blk)
    if args.length == 1
      args[0] = (Units::Converter.converter(args[0]) rescue nil) if not args[0].is_a? Units::Converter
      return Units::Unit.new({m => 1}, args[0]) if args[0] && args[0].registered?(m)
    elsif (Units::Converter.current.registered?(m) rescue false)
      raise ::ArgumentError, "Wrong number of arguments" if args.length != 0
      return Units::Unit.new({m => 1}, Units::Converter.current)
    end
    ::Exception.with_clean_backtrace("method_missing") {
      super
    }
  end

  def const_missing(c)
    if (Units::Converter.current.registered?(c) rescue false)
      return Units::Unit.new({c => 1}, Units::Converter.current)
    else
      ::Exception.with_clean_backtrace("const_missing") {
        super
      }
    end
  end

  def self.append_features(m)
    m.send(:extend, Units)
    super
  end

  # Executes the block with the current Converter changed to
  # the given Converter. This allows to temporarily change the
  # Converter used by default. A Converter object can be given,
  # or the name of a registered Converter.
  #
  # Example:
  #
  #   with_unit_converter(:uk) {
  #     puts 1.cwt.to(lb) # => 112.0 lb
  #   }
  #
  #   with_unit_converter(:us) {
  #     puts 1.cwt.to(lb) # => 100.0 lb
  #   }
  #
  # See also Converter.current.
  def with_unit_converter(name, &blk) # :yields:
    Units::Converter.with_converter(name, &blk)
  end

  module_function :with_unit_converter

  class Regexps

    NUMBER_REGEXP = /(\-?\d+((?:\.\d+)?(?:[eE][-+]?\d+)?))/
    SINGLE_UNIT_REGEXP = /([a-zA-Z_]+)(?::([a-zA-Z_]+))?(?:\s*\*\*\s*([+-]?\d+))?/
    SINGLE_UNIT_NOC_REGEXP = /[a-zA-Z_]+(?::[a-zA-Z_]+)?(?:\s*\*\*\s*[+-]?\d+)?/ # Violates DRY principle
    MULTIPLE_UNIT_REGEXP = /#{SINGLE_UNIT_NOC_REGEXP}(?:(?:\s+|\s*\*\s*)#{SINGLE_UNIT_NOC_REGEXP})*/
    TOTAL_UNIT_REGEXP = /^\s*(?:1|(#{MULTIPLE_UNIT_REGEXP}))\s*(?:\/\s*(#{MULTIPLE_UNIT_REGEXP})\s*)?$/
    TOTAL_UNIT_NOC_REGEXP = /\s*(?:1|(?:#{MULTIPLE_UNIT_REGEXP}))\s*(?:\/\s*(?:#{MULTIPLE_UNIT_REGEXP})\s*)?/ # Violates DRY principle
    VALUE_REGEXP = /^\s*#{NUMBER_REGEXP}\s*\*?\s*(#{TOTAL_UNIT_NOC_REGEXP})$/

  end

  class BaseUnit

    attr_reader :name, :converter

    def initialize(name, converter = Units::Converter.current)
      name = name.to_sym
      raise ::ArgumentError, "unit #{name.to_s.dump} not registered with #{converter}" if not converter.registered? name
      @name = name
      @converter = converter
    end

    def conversion
      @converter.send(:conversions, @name)
    end

    def ==(other)
      other.is_a?(Units::BaseUnit) && other.name == @name && other.converter == @converter
    end

    alias eql? ==

    def hash
      @name.hash ^ @converter.hash
    end

    def to_s
      if Units::Converter.current.includes?(converter)
        @name.to_s
      else
        "#{@converter}:#{@name}"
      end
    end

    alias inspect to_s

  end

  # This class represents a Unit. A Unit uses a given Converter with
  # a number of registered units in which it can be expressed.
  # A Unit is the product of the powers of other units. In principle, these
  # need not be integer powers, but this may cause problems with rounding.
  # The following code for example returns +false+:
  #   Unit.new(:m => 0.1) * Unit.new(:m => 0.2) == Unit.new(:m => 0.3)
  #
  # Units can be multiplied, divided, and raised to a given power.
  # As an extra, 1 can be divided by a Unit.
  #
  # Examples:
  #
  #   Unit.new(:mi => 1, :s => -1) ** 2 # => mi**2/s**2
  #   Unit.new(:mi => 1, :s => -1) * Unit.new(:s => 1, :usd => -1) # => mi/usd
  #   Unit.new(:mi => 1, :s => -1, Converter.converter(:uk)) *
  #     Unit.new(:s => 1, :usd => -1, Converter.converter(:us)) # => TypeError
  #   1 / Unit.new(:mi => 1, :s => -1) # => s/mi
  class Unit

    attr_reader :units

    # Creates a new (composite) Unit.
    # It is passed a hash of the form <code>{:unit => exponent}</code>, and the
    # Converter to use.
    #
    # Examples:
    #
    #   Unit.new(:m => 1, :s => -1, Converter.converter(:uk)) # => m/s
    #   Unit.new(:mi => 1, :s => -2) # => mi/s**2
    #
    # See also Converter, Converter.converter
    def initialize(units = {}, converter = nil)
      conv = proc { converter ||= Units::Converter.current }
      if units.is_a? ::String
        @units = decode_string(units, conv)
      else
        @units = {}
        units.each_pair do |k, v|
          k = conv[].base_unit(k.to_sym) if not k.is_a? Units::BaseUnit
          @units[k] = v
        end
      end
      normalize_units
    end

    # Raises to the given power.
    def **(p)
      result = {}
      @units.each_pair do |u, e|
        result[u] = e * p
      end
      Units::Unit.new(result)
    end

    # Multiplies with the given Unit.
    def *(other)
      do_op(:*, :+, other)
    end

    # Divides by the given Unit.
    def /(other)
      do_op(:/, :-, other)
    end

    # Returns +true+ iff this Unit has all exponents equal to 0.
    def unitless?
      @units.empty?
    end

    def coerce(other) # :nodoc:
      return [Units::Unit.new({}), self] if other == 1
      Units::Converter.coerce_units(self, other)
    end

    def simplify
      Units::Converter.simplify_unit(self)
    end

    # Returns +true+ iff the two units are equals, <i>i.e.,</i> iff they have
    # the same exponent for all units, and they both use the same Converter.
    def ==(other)
      other.is_a?(Units::Unit) && other.units == units
    end

    alias eql? ==

    def hash
      @units.to_a.map { |e| e.hash }.hash
    end

    # Returns +true+ iff this Unit is compatible with the given
    # Unit. This is less strict than equality because for example hours are
    # compatible with seconds ("we can add them"), but hours are not seconds.
    def compatible_with?(other)
      conv1, conv2 = Units::Converter.coerce_units(self, other)
      conv1.units == conv2.units
    end

    # Returns a human readable string representation.
    def to_s
      numerator = ""
      denominator = ""
      @units.each_pair do |u, e|
        e_abs = e > 0 ? e : -e # This works with Complex too
        (e > 0 ? numerator : denominator) << " #{u.to_s}#{"**#{e_abs}" if e_abs != 1}"
      end
      "#{numerator.lstrip}#{"/" + denominator.lstrip if not denominator.empty?}"
    end

    # Returns +self+.
    def to_unit(converter = nil)
      self
    end

    alias inspect to_s

    def method_missing(m, *args, &blk)
      if args.length == 1
        args[0] = (Units::Converter.converter(args[0]) rescue nil) if not args[0].is_a? Units::Converter
        return self * Units::Unit.new({m => 1}, args[0]) if args[0] && args[0].registered?(m)
      elsif (Units::Converter.current.registered?(m) rescue false)
        raise ::ArgumentError, "Wrong number of arguments" if args.length != 0
        return self * Units::Unit.new({m => 1}, Units::Converter.current)
      end
      ::Exception.with_clean_backtrace("method_missing") {
        super
      }
    end

    private

    def decode_string(s, converter)
      if Units::Regexps::TOTAL_UNIT_REGEXP =~ s
        numerator, denominator = $1, $2
        units = {}
        decode_multiplicative_string(numerator, 1, converter, units) if numerator
        decode_multiplicative_string(denominator, -1, converter, units) if denominator
        units
      elsif /^\s*$/ =~ s
        {}
      else
        raise ::ArgumentError, "Illegal unit string #{s.dump}"
      end
    end

    def decode_multiplicative_string(s, multiplier, converter, result)
      s.scan(Units::Regexps::SINGLE_UNIT_REGEXP) do |conv, unit, exp|
        if unit
          conv = Units::Converter.converter(conv)
        else
          conv, unit = converter[], conv
        end
        exp ||= '1'
        unit = conv.base_unit(unit)
        result[unit] = (result[unit] || 0) + Integer(exp) * multiplier
      end
    end

    def normalize_units
      @units.keys.each do |unit|
        @units.delete(unit) if @units[unit] == 0
      end
    end

    def do_op(op, dual_op, other)
      other = other.to_unit
      raise TypeError, "cannot convert to Unit" unless Units::Unit === other
      result = @units.dup
      other.units.each_pair do |u, e|
        result[u] = 0 if not result[u]
        result[u] = result[u].send(dual_op, e)
      end
      Units::Unit.new(result)
    end

  end

  # This class represents a Value with a numeric value and a Unit.
  # The numeric value can be any Numeric, though it is not recommended
  # to use Values.
  #
  # A Value can be added to, subtracted from and multiplied with another value,
  # though only when both Values are using the same Converter. While multiplication
  # is always possible, adding or subtracting values with incompatible units
  # results in a TypeError. When two units are compatible but not the same,
  # the Value with the larger of the units is converted to the smaller of the units.
  # For example adding 100 seconds and 1 minute, the latter is converted to 60 seconds
  # because a second is smaller than a minute. The result is 160 seconds.
  class Value < Numeric

    # The numeric value of this Value.
    attr_reader :value
    # The Unit of this value.
    attr_reader :unit

    include Comparable

    class << self

      alias old_new new

      private :old_new

      # Creates a new Value with the given numeric value and the given unit.
      # Simply returns the given value if the given unit is unitless,
      # <i>i.e.,</i> when <code>unit.unitless?</code> is true.
      def new(value, *args)
        res = new!(value, *args)
        return res.value if res.unit.unitless?
        res
      end

      def new!(value, *args)
        if ::String === value
          str = *args
          converter = case args.length
                      when 0
                      when 1
                        conv = args[0]
                      else
                        raise ArgumentError, "wrong number of arguments"
                      end
          value, unit = decode_string(value, converter)
        else
          if args.length == 1
            unit = args[0]
          else
            raise ArgumentError, "wrong number of arguments"
          end
        end
        unit = Unit.new(unit) unless unit.is_a?(Unit)
        old_new(value, unit)
      end

    end

    def initialize(value, unit) # :nodoc:
      @value, @unit = value, unit
    end

    %w{ * / }.each do |op|
      eval %{
        def #{op}(other)
          Units::Value.new(*do_multiplicative_op(:#{op}, other))
        end
      }
    end

    %w{ + - modulo remainder % }.each do |op|
      eval %{
        def #{op}(other)
          Units::Value.new(*do_additive_op(:#{op}, other))
        end
      }
    end

    def divmod(other)
      (q, r), unit = *do_additive_op(:divmod, other)
      [q, Units::Value.new(r, unit)]
    end

    def div(other)
      do_additive_op(:div, other)[0]
    end

    def -@ # :nodoc:
      Value.new(-@value, @unit)
    end

    def +@ # :nodoc:
      self
    end

    def **(other) # :nodoc:
      Units::Value.new(@value ** other, @unit ** other)
    end

    def <=>(other) # :nodoc:
      if other == 0
        @value <=> 0
      else
        (self - other).value <=> 0
      end
    rescue TypeError
      nil
    end

    alias eql? ==

    def hash
      @value.hash ^ @unit.hash
    end

    %w{ abs ceil floor next round succ truncate }.each do |op|
      eval %{
        def #{op}
          Units::Value.new(@value.#{op}, @unit)
        end
      }
    end

    %w{ finite? infinite? integer? nan? nonzero? zero? }.each do |op|
      eval %{
        def #{op}
          @value.#{op}
        end
      }
    end

    # Converts this Value to the given Unit.
    # This only works if the Converters used by this Value's Unit
    # and the given Unit are the same. It obviously fails if the
    # Units are not compatible (can't add apples and oranges).
    def to(to_unit, converter = nil)
      raise ArgumentError, "Wrong number of arguments" if converter && !(::String === to_unit)
      to_unit = to_unit.to_unit(converter)
      raise TypeError, "cannot convert to Unit" unless Units::Unit === to_unit
      conv1, conv2 = unit.coerce(to_unit)
      raise TypeError, "incompatible units for operation" if conv1.units != conv2.units
      mult = conv1.multiplier / conv2.multiplier
      Units::Value.new(value * mult, to_unit)
    end

    def coerce(other) # :nodoc:
      if ::Numeric === other
        [Units::Value.new!(other, Units::Unit.new), self]
      else
        super
      end
    end

    # Returns a human readable string representation.
    def to_s
      "#{@value} #{@unit}"
    end

    # Returns a float if this Value is unitless, and raises an
    # exception otherwise.
    def to_f
      val = simplify
      if Units::Value === val
        raise TypeError, "Cannot convert to float"
      else
        val.to_f
      end
    end

    # Returns an int if this Value is unitless, and raises an
    # exception otherwise.
    def to_i
      val = simplify
      if Units::Value === val
        raise TypeError, "Cannot convert to integer"
      else
        val.to_i
      end
    end

    # Returns an int if this Value is unitless, and raises an
    # exception otherwise.
    def to_int
      val = simplify
      if Units::Value === val
        raise TypeError, "Cannot convert to integer"
      else
        val.to_int
      end
    end

    # Forces simplification of the Unit part of this Value. Returns
    # a new Value or a Float.
    def simplify
      mul, new_unit = *@unit.simplify
      if new_unit.unitless?
        @value * mul
      else
        Units::Value.new(@value * mul, new_unit)
      end
    end

    # Returns +self+.
    def to_value(converter = nil)
      self
    end

    alias inspect to_s

    def method_missing(m, *args, &blk)
      if args.length == 1
        args[0] = (Units::Converter.converter(args[0]) rescue nil) if not args[0].is_a? Units::Converter
        return self * Units::Value.new(1, Units::Unit.new({m => 1}, args[0])) if args[0] && args[0].registered?(m)
      elsif (Units::Converter.current.registered?(m) rescue false)
        raise ::ArgumentError, "Wrong number of arguments" if args.length != 0
        return self * Units::Value.new(1, Units::Unit.new({m => 1}, Units::Converter.current))
      end
      ::Exception.with_clean_backtrace("method_missing") {
        super
      }
    end

  private

    def self.decode_string(s, converter)
      if m = Units::Regexps::VALUE_REGEXP.match(s)
        value = m[2].empty? ? Integer(m[1]) : Float(m[1])
        unit = Units::Unit.new(m[3], converter)
        [value, unit]
      else
        raise ::ArgumentError, "Illegal value string #{s.dump}"
      end
    end

    def do_additive_op(op, other)
      other = other.to_value
      raise TypeError, "cannot convert to Value" unless Units::Value === other
      if other.is_a? Units::Value
        conv1, conv2 = unit.coerce(other.unit)
        raise TypeError, "incompatible units for #{op}" if conv1.units != conv2.units
        mult = conv2.multiplier / conv1.multiplier
        if mult > 1
          [value.send(op, other.value * mult), unit]
        else
          mult = conv1.multiplier / conv2.multiplier
          [(value * mult).send(op, other.value), other.unit]
        end
      else
        raise TypeError, "incompatible operands for #{op}"
      end
    end

    def do_multiplicative_op(op, other)
      case other
      when Units::Value
        [value.send(op, other.value), unit.send(op, other.unit)]
      when Units::Unit
        [value, unit.send(op, other)]
      when ::Numeric
        [value.send(op, other), unit]
      else
        # TODO: How to make this work for Units as well?
        #       Problem : how check whether to_value failed without
        #                 masking all exceptions?
        other = other.to_value
        raise TypeError, "cannot convert to Value" unless Units::Value === other
        do_multiplicative_op(op, other)
      end
    end

  end

  # This class handles all conversions between units.
  #
  # There are two kinds of units; those that are not expressed as a function
  # of other units --called base units-- and those that are expressed
  # as a function of other units --called derived units. The latter kind is
  # registered specifying how it depends on other units, while the former
  # kind is not.
  #
  # This class also registers a list of Converters that are generally useable.
  # The default Converter which is used when none is specified, can be retrieved
  # with Converter.current. Converters can be registered with Converter.register.
  #
  # Converters can be loaded from YAML. This allows Converters to be specified in
  # configuration files.
  class Converter

    Conversion = Struct.new(:units, :multiplier) # :nodoc:

    class Conversion # :nodoc:

      def **(p)
        Conversion.new(units ** p, multiplier ** p)
      end

      def *(m)
        Conversion.new(units * m.units, multiplier * m.multiplier)
      end

      def /(m)
        Conversion.new(units / m.units, multiplier / m.multiplier)
      end

    end

    ShiftedConversion = Struct.new(:delta_type, :offset)

    # Returns the name of this Converter, or <tt>nil</tt> if the
    # Converter is not registered.
    attr_accessor :name
    private :name=

    # Creates a new Converter. If a block is given,
    # it is executed in the newly created Converter's context.
    def initialize(name)
      @conversions = {}
      @included = []
      @name = name
    end

    # Included the given converter in the receiver, unless it
    # was already included.
    def include(conv)
      conv = Units::Converter.converter(conv) if not conv.is_a?(Units::Converter)
      raise "Circular include" if conv.includes?(self)
      @included << conv if not includes? conv
      self
    end

    # Returns whether the given converter was included in the
    # receiver.
    def includes?(conv)
      conv = Units::Converter.converter(conv) if not conv.is_a?(Units::Converter)
      return true if conv == self
      @included.each do |c|
        return true if conv == c || c.includes?(conv)
      end
      false
    end

    # Returns the list of all included converters. This list may
    # contain duplicates in some cases.
    def included_converters(result = [])
      result << self
      @included.reverse_each { |c| c.included_converters(result) }
      result
    end

    # Checks whether the unit with the given name is registered.
    # The name can be a symbol or a string.
    def registered?(unit)
      unit = unit.to_sym
      return self if registered_here?(unit)
      @included.reverse_each do |c|
        if res = c.registered?(unit)
          return res
        end
      end
      nil
    end

    # Returns the base unit with this name
    def base_unit(name)
      if conv = registered?(name)
        return Units::BaseUnit.new(name, conv)
      end
      raise "unit #{name.to_s.dump} not registered with #{self}"
    end

    # Returns the list of registered unit names as symbols.
    def registered_units
      @conversions.keys
    end

    #
    def method_missing(m, *args, &blk)
      if registered?(m)
        raise ::ArgumentError, "Wrong number of arguments" if args.length != 0
        return Units::Unit.new({m => 1}, self)
      end
      ::Exception.with_clean_backtrace("method_missing") {
        super
      }
    end

    # Returns a human readable string representation of this Converter.
    def to_s
      (@name.to_s if @name) || "#<Converter:#{object_id.to_s(16)}>"
    end

    alias inspect to_s

  private

    # Registers a new Unit with the given name. The +data+ parameter
    # is a Hash with some extra parameters (can be Strings or Symbols):
    # +alias+:: Specifies possible aliases for the Unit.
    # +abbrev+:: Specifies possible abbreviations or symbols for the Unit.
    #            The differences with aliases is that prefixes work differently;
    #            see +register_si_unit+, +register_binary_unit+ and
    #            +register_binary_iec_unit+.
    # +equals+:: If present, specifies how the Unit depends on other units.
    #            The value for this key can either be a Hash with +unit+ mapping to
    #            a Unit and +multiplier+ mapping to a numeric multiplier, or
    #            a String containing the multiplier, followed by a space, followed by
    #            a representation of the Unit as returned by Unit#to_s.
    #
    # Examples:
    #
    #   converter.register_unit(:pint, :alias => :pints, :abbrev => [:pt, :pts]))
    #   converter.register_unit(:quart, 'alias' => :quarts, :abbrev => ['qt', :qts], :equals => '2.0 pt'))
    #   converter.register_unit(:gallon, :alias => :gallons, :abbrev => :gal, 'equals' => {:unit => Unit.new('qt' => 1, converter), 'multiplier' => 4.0))
    #
    # Note that Symbols and Strings are generally exchangeable within this
    # library (internally they are converted to Symbols). The number one reason
    # for this is that String look better in YAML.
    #
    # See also +register_si_unit+, +register_binary_unit+, +register_binary_iec_unit+,
    # +register_length_unit+, and +register_currency+ in currency.rb.
    def register_unit(unit, abbrevs=[], aliases=[], &conversion)
      unit    = unit.to_sym
      abbrevs = [abbrevs].flatten.map{ |a| a.to_sym }
      aliases = [aliases].flatten.map{ |a| a.to_sym }
      #aliases = ["#{unit}s".to_sym] if aliases.empty? # TRANS: hmm... not here?
      #unit, aliases, abbrevs = extract_data(name, data, :to_sym)
      #conversion = data[:equals]
      # TRANS: this can be imporved now that conversion is a block?
      conversion = conversion.call if conversion
      conversion = decode_conversion(conversion) if conversion
      conversion = self.class.convert_conversion(conversion[:unit].units, conversion[:multiplier]) if conversion
      register_unit_internal(unit, conversion)
      conversion = self.class.convert_conversion({base_unit(unit) => 1}, 1) if not conversion
      (aliases + abbrevs).each do |u|
        register_unit_internal(u, conversion)
      end
    end

    def register_unit_internal(unit, conversion)
      raise "unit #{unit.to_s.dump} already registered with #{self}" if registered_here? unit
      @conversions[unit] = conversion || :none
    end

    def register_prefixed_unit(unit, prefixes, abbrevs=[], aliases=[], &conversion)
      unit = unit.to_s
      abbrevs = [abbrevs].flatten.map{ |a| a.to_s }
      aliases = [aliases].flatten.map{ |a| a.to_s }
      aliases = ["#{unit}s"] if aliases.empty?
      #aliases, abbrevs = extract_data(unit, data, :to_s)
      register_unit(unit, abbrevs, aliases, &conversion)
      unit_sym = unit.to_sym
      prefixes.each_pair do |pre,info|
        abbrev     = info[:abbrev]
        multiplier = info[:multiplier] || 1
        power      = info[:power] || 1
        register_unit(pre + unit) do
          {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier}
        end
        aliases.each do |a|
          register_unit(pre + a) do
            {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier}
          end
        end
        abbrevs.each do |a|
          register_unit(abbrev + a) do
            {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier}
          end
        end
      end
    end

    def decode_conversion(data)
      if not data.is_a? ::String
        return {:unit => data[:unit] || data['unit'],
                :multiplier => data[:multiplier] || data['multiplier']}
      end
      if /^\s*1\s*\// =~ data
        {:unit => Units::Unit.new(data, self)}
      elsif m = /^\s*#{Units::Regexps::NUMBER_REGEXP}(?:\s+(\S.*)$|\s*$)/.match(data)
        unit = m[3] ? Units::Unit.new(m[3], self) : Units::Unit.new({}, self)
        if m[1]
          multiplier = m[2].empty? ? Integer(m[1]) : Float(m[1])
          {:unit => unit, :multiplier => multiplier}
        else
          {:unit => unit}
        end
      else
        {:unit => Units::Unit.new(data, self)}
      end
    end

    # Checks whether the unit with the given name is registered.
    # The name can be a symbol or a string.
    def registered_here?(unit)
      unit = unit.to_sym
      conversions(unit) != nil
    end

    def conversions(unit)
      @conversions[unit] #|| (unit == :'--base-currency--' ? :none : nil)
    end

    class << self

      THREAD_REFERENCE = 'Units::converter'.to_sym

      private :new

      # Returns the current Converter in the current Thread.
      # The default converter is the one returned by <code>converter(:default)</code>.
      # See also Units#with_converter and Converter.converter.
      def current
        Thread.current[THREAD_REFERENCE] ||= converter(:default)
      end

      def with_converter(conv) # :nodoc:
        conv = converter(conv) if not conv.is_a? Units::Converter
        raise ::ArgumentError, "Converter expected" if not conv.is_a? Units::Converter
        begin
          old_conv = Thread.current[THREAD_REFERENCE]
          if old_conv
            new_conv = Converter.send(:new, nil)
            new_conv.include(old_conv)
            new_conv.include(conv)
          else
            new_conv = conv
          end
          Thread.current[THREAD_REFERENCE] = new_conv
          yield
        ensure
          Thread.current[THREAD_REFERENCE] = old_conv
        end
      end

      # Returns the converter with the given name.
      # This name can be a Symbol or a String.
      def converter(name, &blk)
        if blk
          (converters[name.to_sym] ||= new(name.to_sym)).instance_eval(&blk)
        else
          converters[name.to_sym] or raise ::ArgumentError, "No converter #{name.to_s.dump} found"
        end
      end

#       # Registers the given Converter under the given name.
#       # This name can be a Symbol or a String. A Converter
#       # can be registered under one name only, and only one
#       # Converter can be registered under a given name.
#       def register(name, converter)
#         name = name.to_sym
#         return if converters[name] == converter
#         raise ArgumentError, "This converter is already registered under anoher name" if converter.name
#         raise ArgumentError, "A converter with this name already exists" if converters[name]
#         converters[name] = converter
#         converter.name ||= name
#       end

      # Returns the list of names of registered converters.
      def registered_converters
        converters.keys
      end

      def coerce_units(unit1, unit2) # :nodoc:
        [convert_conversion(unit1.units), convert_conversion(unit2.units)]
      end

      def simplify_unit(unit) # :nodoc:
        conv = convert_conversion(unit.units)
        [conv[:multiplier], conv[:units]]
      end

      def convert_conversion(units, multiplier = nil)
        multiplier ||= 1
        base_units = {}
        other_units = {}
        units.each_pair do |u, e|
          (u.conversion != :none ? other_units : base_units)[u] = e
        end
        result = Conversion.new(Units::Unit.new(base_units, self), multiplier)
        other_units.each_pair do |u, e|
          result *= (u.conversion ** e)
        end
        result
      end

      def converters
        @converters ||= {}
      end

    end

  end

  # Contains some configuration related constants.
  # TODO: Use plugin manager to find units.
  module Config
    # The directory in which the data files are searched for
    #DATADIR = 'data/stick/units'  #DATADIR = File.join(::Config::CONFIG['DATADIR'], 'stick', 'units')
    #CONFIGDIR = 'lib/stick/data'  #DATADIR = File.join(::Config::CONFIG['DATADIR'], 'stick', 'units')
    SYSTEMDIR = File.dirname(File.dirname(File.dirname(__FILE__)))
    CONFIGDIR = File.join(SYSTEMDIR, 'plugin/stick')
  end

end
end

class Numeric
  #
  def method_missing(m, *args, &blk)
    if args.length == 1
      args[0] = (Stick::Units::Converter.converter(args[0]) rescue nil) if not args[0].is_a?(Stick::Units::Converter)
      return Stick::Units::Value.new(self, Stick::Units::Unit.new({m => 1}, args[0])) if args[0] && args[0].registered?(m)
    elsif Stick::Units::Converter.current.registered?(m)
      raise ::ArgumentError, "Wrong number of arguments" if args.length != 0
      return Stick::Units::Value.new(self, Stick::Units::Unit.new({m => 1}, Stick::Units::Converter.current))
    end
    ::Exception.with_clean_backtrace("method_missing") {
      super
    }
  end

  #
  def to_value(unit)
    Stick::Units::Value.new(self, unit)
  end
end


class String
  #
  def to_unit(converter = nil)
    Stick::Units::Unit.new(self, converter)
  end

  #
  def to_value(converter = nil)
    Stick::Units::Value.new(self, converter)
  end
end
