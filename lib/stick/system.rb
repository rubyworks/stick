require 'stick/frame'
require 'stick/type'
require 'stick/prefix'
require 'stick/measure'

module Stick

  # Alawys use :au as fallback system.
  def self.use(*system_names)
    @use ||= []

    return @use if system_names.empty?

    system_names.each do |name|
      name = name.to_sym
      next if @use.include?(name)
      sys = Stick.systems[name]
      raise "unknown system -- #{name}" unless sys
      ::Numeric.class_eval do
        include sys.numeric_module
      end
      @use << name
    end

    return @use
  end

  #
  def self.systems
    @systems ||= {}
  end

  #
  def self.system(name, *frame, &block)
    sys = System.new(name, *frame, &block)
    systems[name.to_sym] = sys
    (class << self ; self ; end).class_eval do
      define_method(name){ sys }
    end
  end

  #
  #def self.method_missing(system_name)
  #  systems[system_name]
  #end

  #def self.convert(from, goal, &block)
  #  if String == from
  #    system, type = *from.split(':')
  #    from = @systems[system.to_sym].types[type.to_sym]
  #  end
  #  from.conversion(goal, &block)
  #end

  # = System
  #
  # A system defines a set of unit types, prefix factors that can be used with
  # them and conversions to unit types in the system and without.
  #
  # All the systems defined via Stick utilize the AU system as a basis for
  # fallback conversion. By ensuring that the unit types can be converted to
  # and from AU units, then they can be converted to and form any other unit 
  # system as well. See Frame class for more information.
  #
  class System

    # Name of system. This should be a short, two or three letter
    # abbreviated name, eg. 'si'.
    attr :name

    # Unit types in the system.
    attr :types

    # Prefixes recognized by the system.
    attr :prefixes

    #
    def initialize(name, *frame) #:yield:
      @name  = name.to_sym
      @frame = Frame.new(*frame.flatten) unless frame.empty?
      @types    = {}
      @prefixes = []

      # used to track universal conversions
      @universal_conversions = {}

      yield(self) if block_given?
    end

    #

    def frame
      @frame
    end

    # Define a prefix multiplier for this system.

    def prefix(name, symbol, factor)
      prefixes << Prefix.new(self, name, symbol, factor)
    end

    # Define a unit type for this system.

    def unit(name, symbol, quantity, options={})
      type = UnitType.new(self, name, symbol, quantity, options)
      type.terms.each do |key|
        next if /\W/ =~ key.to_s   # can't use non-words characters
        types[key.to_sym] = type
      end

      # define au conversions
      au_conversion(type)
    end

    # Used to access types by term and to assign conversions.

    def method_missing(name, *args)
      case name.to_s
      when /\=$/
        name = name.to_s.chomp('=').to_sym
        type = types.key?(name) ? types[name] : super
        type.conversion(*args)
      else
        name = name.to_sym
        types.key?(name) ? types[name] : super
      end
    end

    #

    def [](conversion)
      parse(conversion)
    end

    #

    def inspect
      "#<System:#{name}>"
    end

    #

    def to_s
      "#{name}"
    end

    # Returns a module to be included into Numeric.

    def numeric_module
      methods = {}
      prefix_types, bare_types = *types.values.uniq.partition{ |t| t.prefix? }

      prefix_types.each do |type|
        prefixes.each do |prefix|
          name = "#{prefix.symbol}#{type.symbol}".to_sym
          methods[name]  = Unit.new(type, 1, prefix)
        end
        type.terms.each do |name|
          next if /\W/ =~ name.to_s   # can't use non-words characters
          methods[name] = Unit.new(type, 1)
        end
      end

      bare_types.each do |type|
        type.terms.each do |name|
          next if /\W/ =~ name.to_s   # can't use non-words characters
          methods[name] = Unit.new(type, 1)
        end
      end

      mod = Module.new

      mod.module_eval do
        methods.each do |name, unit|
          define_method(name) do
            Measure.new(self, unit)
          end
        end
      end

      prefixes.each do |prefix|
        mod.module_eval do
          define_method(prefix.name) do
            prefix
          end
        end
      end

      mod
    end

    # The @universal_conversions hash is used to prevent
    # secondary unit types of like quantities from replacing
    # the conical types. When defining conversions, always put
    # the concical types first.
    #
    # TODO: Add concical option to UnitType class, so they can be skipped.

    def au_conversion(type)
      return nil if type.system == :au
      return nil if @universal_conversions[type.quantity]
      au_system = Stick.systems[:au]
      au_type   = au_system.types.values.find{ |u| u.quantity == type.quantity }
      return nil unless au_type
      au_measure = au_type.base
      #au_measure = au_type.measure
      f = 1
      au_measure.units.each do |u|
        f *= (frame.A(u.symbol) ** u.power)
      end
      au_type * f

      this_to_au = type.conversion(au_type * f)
      au_to_this = au_type.conversion(type / f)

      @universal_conversions[type.quantity] = [this_to_au, au_to_this]
    end

    #

    def ==(other)
      case other
      when Symbol
        name == other
      else
        super
      end
    end


    private

    # Parse a conversion string. This method makes it possible
    # to define conversions using a concise string-based notation.
    # Simply separate units by name or symbol and optionally suffix
    # them with a power. A single division ("/") can also be used.
    #
    #   si.N = "kg m / s2"
    #
    # If the unit is from another unit system, prefix the unit
    # with the systems name and a colon.
    #
    #   us.nmi = "si:nmi"
    #
    # Currently this does not support prefixes or plain numbers.
    #--
    # TODO: Support prefixes in string conversions.
    # TODO: Support numbers in string conversions.
    #++
    def parse(conversion)
      numerator, denominator = *conversion.split('/')
      numerator = numerator.strip.split(/\s+/)
      numerator = numerator.inject(1) do |c, n|
        c * parse_segment(n)
      end

      if denominator
        denominator = denominator.strip.split(/\s+/)
        denominator = denominator.inject(1) do |c, d|
          c * parse_segment(d)
        end
        result = numerator / denominator
      else
        result = numerator
      end
      result
    end

    # Parse a conversion string segment.
    def parse_segment(segment)
      case segment
      when /(\w+):(\w+)(\d+)/
        systems[$1.to_sym].types[$2.to_sym] ** $3.to_i
      when /(\w+):(\w+)[-](\d+)/
        systems[$1.to_sym].types[$2.to_sym] ** -($3.to_i)
      when /(\w+):(\w+)/
        systems[$1.to_sym].types[$2.to_sym]
      when /(\w+)(\d+)/
        types[$1.to_sym] ** $2.to_i
      when /(\w+)[-](\d+)/
        types[$1.to_sym] ** -($2.to_i)
      when /(\w+)/
        types[$1.to_sym]
      when /(\d+)/
        ($1.to_i)
      when /[-](\d+)/
        -($1.to_i)
      end
    end

  end

end

