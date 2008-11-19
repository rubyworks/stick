# = units.rb
#
# == Copyright (c) 2005 Peter Vanbroekhoven
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
# == Author(s)
#
# * Peter Vanbroekhoven

# Author::    Peter Vanbroekhoven
# Copyright:: Copyright (c) 2005 Peter Vanbroekhoven
# License::   Ruby License

require 'rbconfig'
require 'soap/wsdlDriver'
require 'yaml'

# = Units
#
# This is a very extensive SI units system.
#
# == Usage
#
# Here are some examples of usage.
#
#   1.bit/s + 8.bytes/s
#   (1.bit/s).to(byte/s)
#   1.mile.to(feet)
#   1.acre.to(yd**2)
#   1.acre.to(sq_yd)
#   1.gallon.to(self.L)
#   1.lb.to(kg)
#   1.m.s.to(m.s)
#   1.sq_mi.to(km**2)
#   1.mile.to(km)
#   1.usd.to(twd)
#
# == Notes
#
# The namespace for all unit related classes. Mixing this in has the additional effect
# of making Units.with_unit_converter available without the <code>Units.</code> prefix,
# as well as the shortcuts for creating Units (see Units#method_missing).

module Units

  def method_missing(m, *args, &blk)
    if args.length == 1
      args[0] = Units::Converter.converter(args[0]) if not args[0].is_a? Units::Converter
      return Units::Unit.new({m => 1}, args[0]) if args[0].registered?(m)
    elsif Units::Converter.current.registered?(m)
      raise ArgumentError, "Wrong number of arguments" if args.length != 0
      return Units::Unit.new({m => 1}, Units::Converter.current)
    end
    super
  end

  # Executes the block with the current Converter changed to
  # the given Converter. This allows to temporarily change the
  # Converter used by default.
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

  # This class represents a Unit. A Unit uses a given Converter with
  # a number of registered Units in which it can be expressed.
  # A Unit is the product of the powers of other Units. In principle, these
  # need not be integer powers, but this may cause problems with rounding.
  # The following code for example returns +false+:
  #   Unit.new(:m => 0.1) * Unit.new(:m => 0.2) == Unit.new(:m => 0.3)
  #
  # Units can be multiplied and divided, or raised to a given power.
  # This can only be done when both units use the same Converter.
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

    attr_reader :units, :converter

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
    def initialize(units = {}, converter = Units::Converter.current)
      @units, @converter = {}, converter
      units.each_pair { |k, v| @units[k.to_sym] = v }
      check_units
    end

    # Raises to the given power.
    def **(p)
      result = {}
      @units.each_pair do |u, e|
        result[u] = e * p
      end
      Units::Unit.new(result, @converter)
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
      return [self, Units::Unit.new({}, converter)] if other == 1
      raise TypeError, "incompatible converters" if converter != other.converter
      converter.coerce_units(self, other)
    end

    # Returns +true+ iff the two Units are equals, <i>i.e.,</i> iff they have
    # the same exponent for all units, and they both use the same Converter.
    def ==(other)
      other.is_a?(Units::Unit) && other.units == units && other.converter == converter
    end

    # Returns +true+ iff this Unit is compatible with the given
    # Unit. This is less strict than equality because for example hours are
    # compatible with seconds ("we can add them"), but hours are not seconds.
    def compatible_with?(other)
      return false if converter != other.converter
      conv1, conv2 = converter.coerce_units(self, other)
      conv1.units == conv2.units
    end

    # Returns a human readable string representation.
    def to_s
      numerator = ""
      denominator = ""
      @units.each_pair do |u, e|
        (e > 0 ? numerator : denominator) << " #{u.to_s}#{"**#{e.abs}" if e.abs != 1}"
      end
      "#{numerator.lstrip}#{"/" + denominator.lstrip if not denominator.empty?}"
    end

    alias inspect to_s

    def method_missing(m, *args, &blk)
      if converter.registered?(m)
        raise ArgumentError, "Wrong number of arguments" if args.length != 0
        return Units::Unit.new({m => 1}, converter) * self
      end
      super
    end

    private

    def check_units
      @units.keys.each do |unit|
        raise ArgumentError, "unit #{unit.to_s.dump} not registered" if not @converter.registered? unit
        @units.delete(unit) if @units[unit] == 0
      end
    end

    def do_op(op, dual_op, other)
      raise TypeError, "incompatible converters for #{op}" if converter != other.converter
      result = @units.dup
      other.units.each_pair do |u, e|
        result[u] = 0 if not result[u]
        result[u] = result[u].send(dual_op, e)
      end
      Units::Unit.new(result, @converter)
    end

  end

  # This class represents a Value with a numeric value and a Unit.
  # The numeric value can be any Numeric, though it is not recommended
  # to use Values.
  #
  # A Value can be added to, subtracted from and multiplied with another value,
  # though only when both Values are using the same Converter. While multiplication
  # is always possible, adding or subtracting values with incompatible Units
  # results in a TypeError. When two Units are compatible but not the same,
  # the Value with the larger of the Units is converted to the smaller of the Units.
  # For example adding 100 seconds and 1 minute, the latter is converted to 60 seconds
  # because a second is smaller than a minute. The result is 160 seconds.
  class Value < Numeric

    # The numeric value of this Value.
    attr_reader :value
    # The Unit of this value.
    attr_reader :unit

    # Creates a new Value with the given numeric value and the given unit.
    # Simply returns the given value if the given unit is valueless,
    # <i>i.e.,</i> when <code>unit.unitless?</code> is true.
    def self.new(value, unit)
      return value if unit.unitless?
      super
    end

    def initialize(value, unit) # :nodoc:
      @value, @unit = value, unit
    end

    # Returns the Converter used by this Value's Unit.
    # Equivalent to <code>unit.converter</code>.
    def converter
      unit.converter
    end

    def *(other) # :nodoc:
      do_multiplicative_op(:*, other)
    end

    def /(other) # :nodoc:
      do_multiplicative_op(:/, other)
    end

    def +(other) # :nodoc:
      do_additive_op(:+, other)
    end

    def -(other) # :nodoc:
      do_additive_op(:-, other)
    end

    def ==(other) # :nodoc:
      (self - other).value == 0.0
    end

    # Converts this Value to the given Unit.
    # This only works if the Converters used by this Value's Unit
    # and the given Unit are the same. It obviously fails if the
    # Units are not compatible (can't add apples and oranges).
    def to(to_unit)
      conv1, conv2 = unit.coerce(to_unit)
      raise TypeError, "incompatible units for operation" if conv1.units != conv2.units
      mult = conv1.multiplier / conv2.multiplier
      Value.new(value * mult, to_unit)
    end

    def coerce(other) # :nodoc:
      [self, Value.new(other, Units::Unit.new({}, @unit.converter))]
    end

    # Returns a human readable string representation.
    def to_s
      "#{@value} #{@unit}"
    end

    alias inspect to_s

    def method_missing(m, *args, &blk)
      if self.converter.registered?(m)
        raise ArgumentError, "Wrong number of arguments" if args.length != 0
        return self * Value.new(1, Units::Unit.new({m => 1}, self.converter))
      end
      super
    end

  private

    def do_additive_op(op, other)
      if other.is_a? Value
        conv1, conv2 = unit.coerce(other.unit)
        raise TypeError, "incompatible units for #{op}" if conv1.units != conv2.units
        mult = conv2.multiplier / conv1.multiplier
        if mult > 1
          Value.new(value.send(op, other.value * mult), unit)
        else
          Value.new(other.value.send(op, value * mult), other.unit)
        end
      else
        raise TypeError, "incompatible operands for #{op}"
      end
    end

    def do_multiplicative_op(op, other)
      if other.is_a? Value
        Value.new(value.send(op, other.value), unit.send(op, other.unit))
      elsif other.is_a? Units::Unit
        Value.new(value, unit.send(op, other))
      else
        Value.new(value.send(op, other), unit)
      end
    end

  end

  # This class handles all conversions between Units.
  #
  # There are two kinds of Units; those that are not expressed as a function
  # of other Units --called base units-- and those that are expressed
  # as a function of other Units --called derived units. The former kind is
  # registered without specifying how it depends on other Units, while the latter
  # kind is registered with doing so.
  #
  # This class also registers a list of Converters that are generally useable.
  # The default Converter which is used when none is specified, can be retrieved
  # with Converter.current. Converters can be registered with Converter.register.
  #
  # Converters can be loaded from YAML. This allows Converters to be specified in
  # configuration files.
  class Converter

    # Encapsulates a service for retrieving exchange rates.
    # This is used by Converter.register_currency.
    # An instance of this class behaves like a Numeric when used
    # in calculations. This class is used to look up exchange rates
    # lazily.
    #
    # This class is not supposed to be instantiated by itself. Instead a
    # subclass should be created that defines the method +get_rate+.
    # The only subclass provided is currently XMethods.
    #
    # To be found automatically from YAML files, exchange services should
    # be located under Units::Converter::ExchangeRate.
    class ExchangeRate

      def self.create_conversion(curr, converter) # :nodoc:
        {:unit => Units::Unit.new({%s{--base-currency--} => 1}, converter), :multiplier => self.new(curr)}
      end

      def initialize(curr) # :nodoc:
        @curr = curr
      end

      # This method should be overridden in subclasses to return the
      # exchange rate represented by this object. The unit in question
      # is available as a String in the instance variable <code>@curr</code>.
      # The rate should be calculated against an arbitrary but fixed base currency.
      # The rate should be such that the following would be true
      #   1 * curr = rate * base_curr
      # This function should return +nil+ if the currency is not supported by this
      # retrieval service. It should <em>not</em> raise an exception.
      def get_rate
        raise NoMethodError, "undefined method `get_rate' for #{to_s}:#{self.class}"
      end

      def value # :nodoc:
        @value ||= get_rate or raise TypeError, "currency not supported by current service: #{@curr.to_s.dump}"
      end

      def coerce(other) # :nodoc:
        [value, other]
      end

      def *(other) # :nodoc:
        value * other
      end

      def /(other) # :nodoc:
        value / other
      end

      def +(other) # :nodoc:
        value + other
      end

      def -(other) # :nodoc:
        value - other
      end

      def **(other) # :nodoc:
        value ** other
      end

      # Exchange rate retrieval service that uses a service from http://www.xmethods.com.
      # See http://rubyurl.com/7uq.
      class XMethods < ExchangeRate

        # This is the only method that a subclass of ExchangeRate
        # needs to implement. This is a good example to follow.
        def get_rate
          driver.getRate(country_mapping[@curr], country_mapping[base])
        rescue
          nil
        end

        private

        def data
          @@data ||= YAML.load_file(File.join(Units::Config::DATADIR, 'xmethods', 'mapping.yaml'))
        end

        def country_mapping
          @@country_mapping ||= data[:mapping]
        end

        def base
          @@base ||= data[:base]
        end

        def driver
          @@driver ||= SOAP::WSDLDriverFactory.new("http://www.xmethods.net/sd/2001/CurrencyExchangeService.wsdl").create_rpc_driver
        end

      end

      # Cached values for the XMethods exchange rate service.
      class CachedXMethods < ExchangeRate

        # This is the only method that a subclass of ExchangeRate
        # needs to implement. This is a good example to follow.
        def get_rate
          data[@curr]
        end

        private

        def data
          @@data ||= YAML.load_file(File.join(Units::Config::DATADIR, 'xmethods', 'cached.yaml'))
        end

      end

    end

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

    # The prefixes used for SI units. See also Converter#register_si_unit.
    SI_PREFIXES = {
      'yotta' => {:abbrev => 'Y',  :multiplier => 1e24},
      'zetta' => {:abbrev => 'Z',  :multiplier => 1e21},
      'exa'   => {:abbrev => 'E',  :multiplier => 1e18},
      'peta'  => {:abbrev => 'P',  :multiplier => 1e14},
      'tera'  => {:abbrev => 'T',  :multiplier => 1e12},
      'giga'  => {:abbrev => 'G',  :multiplier => 1e9},
      'mega'  => {:abbrev => 'M',  :multiplier => 1e6},
      'kilo'  => {:abbrev => 'k',  :multiplier => 1e3},
      'hecto' => {:abbrev => 'h',  :multiplier => 1e2},
      'deca'  => {:abbrev => 'da', :multiplier => 1e1},
      'deci'  => {:abbrev => 'd',  :multiplier => 1e-1},
      'centi' => {:abbrev => 'c',  :multiplier => 1e-2},
      'milli' => {:abbrev => 'm',  :multiplier => 1e-3},
      'micro' => {:abbrev => 'u',  :multiplier => 1e-6},
      'nano'  => {:abbrev => 'n',  :multiplier => 1e-9},
      'pico'  => {:abbrev => 'p',  :multiplier => 1e-12},
      'femto' => {:abbrev => 'f',  :multiplier => 1e-15},
      'atto'  => {:abbrev => 'a',  :multiplier => 1e-18},
      'zepto' => {:abbrev => 'z',  :multiplier => 1e-21},
      'yocto' => {:abbrev => 'y',  :multiplier => 1e-24}
    }

    # The prefixes used for binary units. See also Converter#register_binary_unit.
    BINARY_PREFIXES = {
      'yotta' => {:abbrev => 'Y', :multiplier => 1024.0 ** 8},
      'zetta' => {:abbrev => 'Z', :multiplier => 1024.0 ** 7},
      'exa'   => {:abbrev => 'E', :multiplier => 1024.0 ** 6},
      'peta'  => {:abbrev => 'P', :multiplier => 1024.0 ** 5},
      'tera'  => {:abbrev => 'T', :multiplier => 1024.0 ** 4},
      'giga'  => {:abbrev => 'G', :multiplier => 1024.0 ** 3},
      'mega'  => {:abbrev => 'M', :multiplier => 1024.0 ** 2},
      'kilo'  => {:abbrev => 'k', :multiplier => 1024.0},
    }

    # The prefixes used for length units. See also Converter#register_length_unit.
    LENGTH_PREFIXES = {
      'square_' => {:abbrev => 'sq_', :power => 2},
      'cubic_' => {:abbrev => 'cu_', :power => 3}
    }

    # Creates a new Converter, where the data is loaded from the
    # file with the given file name.
    def self.from_yaml(file)
      Units::Converter.new {
        load_yaml(file)
      }
    end

    # Creates a new Converter. If a block is given,
    # it is executed in the newly created Converter's context.
    def initialize(&blk)
      @loaded_yaml = []
      @conversions = {}
      instance_eval(&blk) if blk
    end

    # Checks whether the unit with the given name is registered.
    # The name can be a symbol or a string.
    def registered?(unit)
      unit = unit.to_sym
      conversions(unit) != nil
    end

    # Returns the list of registered unit names as symbols.
    def registered_units
      @conversions.keys
    end

    # Registers a new Unit with the given name. The +data+ parameter
    # is a Hash with some extra parameters (can be Strings or Symbols):
    # +alias+:: Specifies possible aliases for the Unit.
    # +abbrev+:: Specifies possible abbreviations or symbols for the Unit.
    #            The differences with aliases is that prefixes work differently;
    #            see +register_si_unit+ and +register_binary_unit+.
    # +equals+:: If present, specifies how the Unit depends on other Units.
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
    # See also +register_si_unit+, +register_binary_unit+, +register_length_unit+
    # and +register_currency+.
    def register_unit(name, data = {})
      unit, aliases, abbrevs = extract_data(name, data, :to_sym)
      conversion = data[:equals]
      conversion = decode_conversion(conversion) if conversion
      conversion = convert_conversion(conversion[:unit].units, conversion[:multiplier]) if conversion
      register_unit_internal(unit, conversion)
      conversion = convert_conversion({unit => 1}, 1) if not conversion
      (aliases + abbrevs).each do |u|
        register_unit_internal(u, conversion)
      end
    end

    # Registers a new SI unit. The Unit and its aliases are registered with
    # all available SI prefixes (see SI_PREFIXES) as well, while the
    # abbreviations are registered with the abbreviated version of the
    # prefixes.
    #
    # For the syntax of the options, see +register_unit+.
    def register_si_unit(unit, data = {})
      register_prefixed_unit(unit, SI_PREFIXES, data)
    end

    # Registers a new binary unit. The Unit and its aliases are registered with
    # all available binary prefixes (see BINARY_PREFIXES) as well, while the
    # abbreviations are registered with the abbreviated version of the
    # prefixes.
    #
    # For the syntax of the options, see +register_unit+.
    def register_binary_unit(unit, data = {})
      register_prefixed_unit(unit, BINARY_PREFIXES, data)
    end

    # Registers a new length unit. The Unit and its aliases are registered with
    # all available length prefixes (see LENGTH_PREFIXES) as well, while the
    # abbreviations are registered with the abbreviated version of the
    # prefixes.
    #
    # For the syntax of the options, see +register_unit+.
    def register_length_unit(unit, data = {})
      register_prefixed_unit(unit, LENGTH_PREFIXES, data)
    end

    # Registers a given currency, with a given servive to find the exchange
    # rate between the given currency and a given base currency. The service
    # should be a subclass of ExchangeRate. This is not strictly necessary,
    # but ExchangeRate handles all of the magic.
    def register_currency(curr, service = nil)
      service ||= Units::Config::DEFAULT_CURRENCY_SERVICE
      register_unit(curr, :equals => service.create_conversion(curr, self))
    end

    def coerce_units(unit1, unit2) # :nodoc:
      [convert_conversion(unit1.units), convert_conversion(unit2.units)]
    end

    def method_missing(m, *args, &blk)
      if registered?(m)
        raise ArgumentError, "Wrong number of arguments" if args.length != 0
        return Units::Unit.new({m => 1}, self)
      end
      super
    end

    # Loads data from the YAML file with the given name.
    # Returns +self+.
    def load_yaml(file)
      return if @loaded_yaml.include? file
      data = YAML.load_file(file)
      @loaded_yaml << file
      old_service = Thread.current['current_currency_exchange_service']
      data.each do |r|
        rule = {}
        r.each_pair do |k, v|
          rule[k.to_sym] = v
        end
        case rule[:type]
        when 'import'
          load_yaml(File.join(Units::Config::DATADIR, rule[:file] + '.yaml'))
        when 'si'
          register_si_unit(rule[:name], rule)
        when 'unit'
          register_unit(rule[:name], rule)
        when 'length'
          register_length_unit(rule[:name], rule)
        when 'binary'
          register_binary_unit(rule[:name], rule)
        when 'currency'
          register_currency(rule[:name], Thread.current['current_currency_exchange_service'])
        when 'service'
          begin
            Thread.current['current_currency_exchange_service'] = Units::Converter::ExchangeRate.const_get(rule[:name])
          rescue NameError
            raise NameError, "Exchange service not found: #{rule[:name].to_s.dump}"
          end
        else
          raise "unknown rule type #{rule[:type].to_s.dump}"
        end
      end
      Thread.current['current_currency_exchange_service'] = old_service
      self
    end

    # Returns the current Converter in the current Thread.
    # The default converter is the one returned by <code>converter(:default)</code>.
    # See also Units#with_converter and Converter.converter.
    def self.current
      Thread.current["current_unit_converter"] ||= converter(:default)
    end

    def self.with_converter(conv) # :nodoc:
      old_conv = Thread.current["current_unit_converter"]
      if conv.is_a? Units::Converter
        Thread.current["current_unit_converter"] = conv
      else
        Thread.current["current_unit_converter"] = converter(conv)
      end
      yield
    ensure
      Thread.current["current_unit_converter"] = old_conv
    end

    # Returns the converter with the given name.
    # This name can be a Symbol or a String.
    def self.converter(name)
      converters[name.to_sym] or raise ArgumentError, "No converter #{name.to_s.dump} found"
    end

    # Registers the given Converter under the given name.
    # This name can be a Symbol or a String.
    def self.register(name, converter)
      converters[name.to_sym] = converter
    end

    # Returns the list of names of registered converters.
    def self.registered_converters
      converters.keys
    end

  private

    def clean_eval(some_name_noone_uses)
      eval some_name_noone_uses, binding, __FILE__, __LINE__
    end

    def register_unit_internal(unit, conversion)
      raise "unit #{unit.to_s.dump} already registered with #{self}" if registered? unit
      @conversions[unit] = conversion || :none
    end

    def register_prefixed_unit(unit, prefixes, data = {})
      unit, aliases, abbrevs = extract_data(unit, data, :to_s)
      register_unit(unit, :equals => data[:equals], :alias => aliases, :abbrev => abbrevs)
      unit_sym = unit.to_sym
      prefixes.each_pair do |pre,info|
        abbrev = info[:abbrev]
        multiplier = info[:multiplier] || 1
        power = info[:power] || 1
        register_unit(pre + unit, :equals => {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier})
        aliases.each do |a|
          register_unit(pre + a, :equals => {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier})
        end
        abbrevs.each do |a|
          register_unit(abbrev + a, :equals => {:unit => Units::Unit.new({unit_sym => power}, self), :multiplier => multiplier})
        end
      end
    end

    def extract_data(unit, data, conv)
      sarray = proc do |k|
        list = data[k] || []
        list = [list] if not list.is_a? Array
        list.map { |a| a.send(conv) }
      end
      unit = unit.send(conv)
      return unit, sarray[:alias], sarray[:abbrev].select { |a| a != unit }
    end

    def decode_conversion(data)
      if not data.is_a? String
        return {:unit => data[:unit] || data['unit'],
                :multiplier => data[:multiplier] || data['multiplier']}
      end
      data.rstrip!
      if m = /^(\d+(\.\d+(?:[eE][-+]?\d+)?)?(?:\s+|$))?(.+)?$/.match(data)
        unit = m[3] ? clean_eval(m[3].gsub(/\b([A-Z]\w*|in)\b/, 'self.\1')) : Units::Unit.new({}, self)
        if m[1]
          multiplier = m[2] ? Float(m[1]) : Integer(m[1])
          {:unit => unit, :multiplier => multiplier}
        else
          {:unit => unit}
        end
      else
        raise ArgumentError, "Wrong unit string"
      end
    end

    def convert_conversion(units, multiplier = nil)
      multiplier ||= 1
      base_units = {}
      other_units = {}
      units.each_pair do |u, e|
        (conversions(u) != :none ? other_units : base_units)[u] = e
      end
      result = Conversion.new(Units::Unit.new(base_units, self), multiplier)
      other_units.each_pair do |u, e|
        result *= (conversions(u) ** e)
      end
      result
    end

    def conversions(unit)
      @conversions[unit] || (unit == %s{--base-currency--} ? :none : nil)
    end

    def self.converters
      @converters ||= {}
    end

  end

  # Contains some configuration related constants
  module Config
    # The directory in which the data files are searched for
    DATADIR = File.join(File.dirname(__FILE__), 'units')

    #begin
    #  if ::Gem.active?('facets')
    #    DATADIR = File.join( ::Gem.gempath('facets'), 'data', 'facets', 'units' )
    #  else
    #    DATADIR = File.join( ::Config::CONFIG['datadir'], 'facets', 'units' )
    #  end
    #rescue
    #  DATADIR = File.join( ::Config::CONFIG['datadir'], 'facets', 'units' )
    #end

    # The standard service used for looking up currency exchange rates
    DEFAULT_CURRENCY_SERVICE = Units::Converter::ExchangeRate::XMethods
  end

  #-- Initialization after everything is set up
  class Converter
    standard_converters = YAML.load_file(File.join(Units::Config::DATADIR, 'standard.yaml'))
    standard_converters.each do |name|
       register(name, Units::Converter.from_yaml(File.join(Units::Config::DATADIR, name + ".yaml")))
    end
  end

end

class Numeric

  def method_missing(m, *args, &blk)
    if args.length == 1
      args[0] = Units::Converter.converter(args[0]) if not args[0].is_a? Units::Converter
      return Value.new(self, Units::Unit.new({m => 1}, args[0])) if args[0].registered?(m)
    elsif Units::Converter.current.registered?(m)
      raise ArgumentError, "Wrong number of arguments" if args.length != 0
      return Units::Value.new(self, Units::Unit.new({m => 1}, Units::Converter.current))
    end
    super
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  include Units

  class TC01 < Test::Unit::TestCase

    def test_01_001
      assert_equal( "65.0 bit/s", (1.bit/s + 8.bytes/s).to_s )
    end

    def test_01_002
      assert_equal( "0.125 byte/s", ((1.bit/s).to(byte/s)).to_s )
    end

    def test_01_003
      assert_equal( "5280.0 feet", (1.mile.to(feet)).to_s )
    end

    def test_01_004
      assert_equal( "4840.0 yd**2", (1.acre.to(yd**2)).to_s )
    end

    def test_01_005
      assert_equal( "4840.0 sq_yd", (1.acre.to(sq_yd)).to_s )
    end

    def test_01_006
      assert_equal( "3.785411784 L", (1.gallon.to(self.L)).to_s )
    end

    def test_01_007
      assert_equal( "0.45359237 kg", (1.lb.to(kg)).to_s )
    end

    def test_01_008
      r = (1.m.s.to(m.s)).to_s
      assert( "1 s m" == r || "1 m s" == r  )
    end

    def test_01_009
      assert_equal( "2.589988110336 km**2", (1.sq_mi.to(km**2)).to_s )
    end

    def test_01_010
      assert_equal( "1.609344 km", (1.mile.to(km)).to_s )
    end

    # currency rates change frequently, temp commented
    #def test_01_011
    #  assert_equal( "33.2750003803837 twd", (1.usd.to(twd)).to_s )
    #end

    def test_01_012
      with_unit_converter(:uk) {
        assert_equal( "112.0 lb",  1.cwt.to(lb).to_s )
      }
    end

    def test_01_013
      with_unit_converter(:us) {
        assert_equal( "100.0 lb", 1.cwt.to(lb).to_s )
      }
    end

    def test_01_014
      assert_equal( "112.0 lb", (1.cwt(:uk).to(lb(:uk))).to_s )
      assert_equal( "100.0 lb", (1.cwt(:us).to(lb(:us))).to_s )
    end

    def test_01_015
      assert_equal( "lb", (Converter.current.lb).to_s )
    end

    def test_01_016
      assert(
        [:us, :cex, :default, :uk].all? { |c|
          Converter.registered_converters.include?( c )
        }
      )
    end

    # Money exchange is off line at the moment

    #def test_01_017
    #  assert_raises(TypeError) {
    #    1.try.to(usd)
    #  }
    #end

    #def test_01_016
    #  assert_equal( "33.2190007563597 twd", (1.usd(:cex).to(twd(:cex))).to_s )
    #end

  end

=end
