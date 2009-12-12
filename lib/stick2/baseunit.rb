module Stick

  #
  class BaseUnit

    attr :power

    attr :multiple

    # A base unit has a +power and +a +multiple+.
    def initialize(power=1, multiple=1)
      @power    = power
      @multiple = multiple
    end

    def symbol
      nil
    end

    def term
      raise "must be implemented"
    end

    #
    def singular
      term.to_s.chomp('s')
    end

    #
    def to_s
      s = symbol ? symbol.to_s : term.to_s
      if multiple != 1
        s = "(#{multiple} #{s})"
      end
      if power != 1
        s = s + "#{power}"
      end
      s
    end

    #
    alias_method :inspect, :to_s

    # Convert to <i>least common measure</i>.
    def to_lcm
      self
    end

    # Convert from <i>least common measure</i>.
    def from_lcm
      self
    end

    #
    def invert
      self.class.new(-power, multiple)
    end

    # C L A S S  M E T H O D S

    #
    def self.inherited(base)
      register << base
    end

    def self.register
      @register ||= []
    end

    def self.setup
      register.each do |base|
        sample = base.new
        names = [sample.symbol, sample.term, sample.singular].compact.uniq
        names.each do |name|
          ::Numeric.class_eval do
             define_method(name){ Measure.new(self, Unit.new(base.new)) }
          end
        end
      end
    end

    #
    def ==(other)
      return false unless self.class == other.class
      return false unless power == other.power
      return false unless multiple == other.multiple
      return true
    end

  end

end

