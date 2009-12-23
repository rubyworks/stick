require 'stick2/frame'
require 'stick2/type'
require 'stick2/prefix'
require 'stick2/measure'

module Stick
module Units

  # Alawys use :au as fallback system.
  def self.use(*system_names)
    @use ||= []

    return @use if system_names.empty?

    system_names.each do |name|
      name = name.to_sym
      next if @use.include?(name)
      @use << name
      s = Stick::Units.systems[name]
      ::Numeric.class_eval do
        include s.numeric_module
      end
    end

    return @use
  end

  #
  def self.systems
    @systems ||= {}
  end

  #
  def self.system(name, *frame, &block)
    system = System.new(name, *frame, &block)
    systems[name.to_sym] = system
    (class << self ; self ; end).class_eval do
       define_method(name){ system }
    end
  end

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
  # them and conversions better unit types in the system and without.
  #
  # All the systems defined via Stick utilize the AU system as a basis for
  # fallback conversion. By ensuring that the unit types can be converted to
  # and from AU unit, then they can be converted to and form any other unit 
  # system as well.
  #
  # == Anthropomorphic Natural Units (AU)
  #
  # Stick uses a set of standard units to handle conversions between
  # different unit systems. The system used for this purpose is
  # a natural units system, setting the natural constants as follows:
  #
  #   c = 1        Speed of Light
  #   h = 1        Planck's constant
  #   u = 1        Magnetic constant
  #   G = 1/8 π    Gravitational constant
  #   k = 2        Blotzman's Constant
  #
  # Consequently,
  #
  #   2 π ħ = 1
  #   8 π G = 1
  #
  # Technically the system needs only two base units, the transcendental
  # aesthetics Space (S) and Time (T).
  #
  #   S = (8 π G h / c^3) ^ 1/2
  #   T = (8 π G h / c^5) ^ 1/2
  #
  # While these two units are all that are required to fully derive
  # system of natural units, it is practical to include three important
  # derived units, Mass (M), Charge (Q) and Temperature (H) as follows:
  #
  #   M = (h c / 8 π G) ^ 1/2
  #   Q = (h 4 π / u c) ^ 1/2
  #   H = (h c^5 / 8 π G k^2) ^ 1/2
  #
  # Now we nedd to anthropomorphize these units so they useful at human scale.
  # We do this by applying a <i>anthropomorphic scaling factor</i> to each.
  # If we consider these values in metric (SI units) the constants are:
  #
  #   c = 299,792,458           m        s-1
  #   h = 6.626068960 × 10^-34  m2  kg   s
  #   G = 6.674280000 × 10^-11  m3  kg-1 s-2
  #   ε = 8.854187817 × 10^-12  m-3 kg-1 s4  A2 
  #   k = 1.380650300 × 10^-23  m2  kg   s-2 K-1
  #
  # We get the conversion values for our units as:
  #
  #   S = 2.03104273895475e-34 m
  #   T = 6.77482933528218e-43 s
  #   M = 2.28176272483924e-18 kg
  #   Q = 4.70129630762420e-18 C
  #   H = 5.66272675153234e-24 K
  #
  # Cleary too small for practical use. But useful to as a frame of reference for
  # determining suitable athropomorphic factors.
  #
  #   As = 10^33 (Fre?)  ;)
  #   At = 10^42 (Ada?)  ;)
  #   Am = 10^18 (Exa)
  #   Aq = 10^18 (Exa)
  #   Ah = 10^24 (Yotta)
  #
  # Which gives us out final conversion formulas:
  #
  #   S = (8 π G h / c^3) ^ 1/2      * 10^33
  #   T = (8 π G h / c^5) ^ 1/2      * 10^42
  #   M = (h c / 8 π G) ^ 1/2        * 10^18
  #   Q = (h c 4 π ε) ^ 1/2          * 10^18
  #   H = (h c^5 / 2 π G K^2) ^ 1/2  * 10^24
  # 
  # And in metric, the final conversion ratios:
  #
  #   S = 0.203104273895475 m
  #   T = 0.677482933528218 s
  #   M = 2.281762724839240 kg
  #   Q = 4.701296307624200 C
  #   H = 5.662726751532340 K
  #
  # Or conversely,
  #
  #   1 m  = 4.923579306433680 S
  #   1 s  = 1.476051942433690 T
  #   1 kg = 0.438257663303030 M
  #   1 C  = 0.212707290620733 Q
  #   1 K  = 0.176593369921902 H
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
      yield(self) if block_given?
    end

    #

    def frame
      @frame
    end

    # Define a prefix multiplier for this system.

    def prefix(long, short, factor)
      prefixes << Prefix.new(long, short, factor)
    end

    # Define a unit type for this system.

    def unit(name, symbol, quantity, options={})
      type = UnitType.new(self, name, symbol, quantity, options)
      type.terms.each do |key|
        next if /\W/ =~ key.to_s   # can't use non-words characters
        types[key.to_sym] = type
      end

      au_conversion(type)
      #if auc = au_conversion(type)
      #  type.conversion(auc)
      #end
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
      #list = types.keys.join(', ')
      "#<System:#{name}>"
    end

    # Returns a module to be included into Numeric.

    def numeric_module
      mod = Module.new
      types.each do |key, type|
        mod.module_eval do
          type.terms.each do |m|
            next if /\W/ =~ m.to_s   # can't use non-words characters
            define_method(m) do
              Measure.new(self, Unit.new(type))
            end
          end
        end
      end
      mod
    end

    # TODO: reciporcal conversion
    # TODO: don't do a quantity that has already been done (how?)

    def au_conversion(type)
      return nil if type.system == :au
      au_system = Stick::Units.systems[:au]
      au_type   = au_system.types.values.find{ |u| u.quantity == type.quantity }
      return nil unless au_type
      au_measure = au_type.base
      #au_measure = au_type.measure
      f = 1
      au_measure.units.each do |u|
        f *= (frame.A(u.symbol) ** u.power)
      end
      au_type * f

      type.conversion(au_type * f)
      au_type.conversion(type / f)
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

    # Parse a conversion string.
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
end

