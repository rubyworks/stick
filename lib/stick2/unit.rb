module Stick

  # Set or get the base system.
  def self.system(sym=nil)
    @system = sym if sym
    @system
  end


  # = Base Unit
  #
  class Unit

    include Comparable

    # For working with unit multiples.
    attr :multiple

    # For working with squares, curbics, and so forth.
    attr :power

    # A base measure has a +multiple+ and a +power+.
    def initialize(power=1, multiple=1)
      @power    = power
      @multiple = multiple
    end

    #
    def symbol ; self.class.symbol ; end

    #
    def term ; self.class.term ; end

    #
    def single ; self.class.single ; end

    #
    def system ; self.class.system ; end

    # Convert to <i>measure</i>.
    def to_m
      Measure.new(1, self)
    end

    # Convert to <i>base measure</i>.
    def to_base
      __send__("to_#{Stick.system}")
      #Measure.new(1, self)
    end

    #
    def invert
      self.class.new(-power, multiple)
    end

    #
    def **(number)
      self.class.new(power*number, multiple)
    end

    #
    def to_s
      s = symbol ? symbol.to_s : term.to_s
      if multiple != 1
        s = "(#{multiple} #{s})"
      end
      if power != 1
        s = s + (power > 0 ? "^#{power}" : "#{power}")
      end
      s
    end

    #
    alias_method :inspect, :to_s

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
      return false unless multiple == other.multiple
      return true
    end

    # Compare units.
    #def ===(other)
    #  return false unless self.class == other.class
    #  return false unless power == other.power
    #  #return false unless multiple == other.multiple
    #  return true
    #end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, in less
    # or equal power, then +self+ is a *factor* of the +other+.

    def factor?(other)
      s =  self.to_lcm.unit.map{ |u| [u.class] * u.power }.flatten
      o = other.to_lcm.unit.map{ |u| [u.class] * u.power }.faltten
      (s - o).empty?
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, indifferent
    # of their power, then they are said to be *commensurate* units.

    def commensurate?(other)
      s =  self.to_lcm.unit.map{ |u| u.class }.uniq
      o = other.to_lcm.unit.map{ |u| u.class }.uniq
      (s - o).empty? && (o - s).empty?
    end

    # Reduce +self+ and the +other+ unit to their least comon
    # measures, if the +other+ has all the same unit classes
    # in equal power as +self+, then they are said to be
    # *proportional* units, i.e. their ratio would produce
    # a unitless number.

    def proportional?(other)
      s =  self.to_lcm.unit.map{ |u| u.class }
      o = other.to_lcm.unit.map{ |u| u.class }
      (o - s).empty? && (s - o).empty?
    end

    #
    def unit ; self ; end


    # C L A S S  M E T H O D S

    def self.symbol
      self::SYMBOL
    end

    # Plural term.
    def self.term
      name.split('::').last.downcase + 's'
    end

    # Singular term.
    def self.single
      name.split('::').last.downcase
    end

    #
    def self.system
      eval('::'+name.split('::')[0..-2].join('::'))
    end

    # Convert from <i>least common measure</i>.
    #
    def self.base(measure)
      #measure
      __send__(Stick.system, measure)
    end

    #
    def self.inherited(base)
      register << base
    end

    #
    def self.register
      @@register ||= []
    end

    #
    def self.conversion(system, unit, factor)
      define_method("to_#{system}") do
        Measure.new(factor, unit.new(power))
      end
      (class < self; self; end).class_eval %{
        def #{system}(measure=nil)
          if measure
            measure.reduce # just in case
            raise ArgumentError unless measure.commensurate?(1.__send__(:#{unit}))
            power = measure.units.first.power
            Measure.new(measure.value * (factor ** -1), new(power))
          else
            Measure.new(new)
          end
        end
      }
    end

    #
    def self.setup
      register.each do |base|
        names = [base.symbol, base.term, base.single].compact.uniq
        names.each do |name|
          ::Numeric.class_eval do
            define_method(name){ Measure.new(self, base.new) }
          end
        end
      end
    end

  end

end

