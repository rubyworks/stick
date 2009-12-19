class Object
  alias_method :__inspect__, :inspect
end

class Numeric
  #
  def to_measure #to_m ?
    Stick::Measure.new(self)
  end
end

module Stick

  # A measure has a value-units table.
  #
  # TODO: 3.m.unit - 4.m.unit != []  very bad! why is it so?
 
  class Measure < Numeric

    # The table stores measure units and values.

    attr :table

    # New measure given unit instances or other measures.

    def initialize(*units)
      @table = []
      units.flatten.each do |e|
        case e
        when Measure
          @table.concat(e.table)
        else
          @table << e
        end
      end
      reduce  # TODO: Do this here ?
    end

    # Sum values and merge common units.
    #
    # TODO: Should this be immutable or just private?

    def reduce
      retable = []
      units = table.select{ |u| u.is_a?(Unit) }
      types = units.map{ |u| u.type }.uniq
      group = units.group_by{ |b| b.type }  # TODO: and unit multiple ?
      types.each do |type|
        units = group[type]
        power = 0; units.each{ |u| power += u.power }
        retable << Unit.new(type, power) unless power == 0
      end
      @table = [value, *retable]
      self
    end

    #
    def value
      @value ||= table.select{ |e| e.is_a?(Numeric) }.inject(1){ |v, e| v *= e; v }
    end

    #
    def unit
      @unit ||= table.select{ |e| e.is_a?(Unit) }
    end

    #
    alias_method :units, :unit

    # Is this measure of a single +unit+? If so, this method
    # returns the power of that unit, otherwise nil.

    def pure?(unit)
      return false unless units.size == 1
      return false unless unit === units.first
      return units.first.power
    end

    # Returns +true+ iff this Unit has all exponents equal to 0.

    def unitless?
      units.empty?
    end


    # C O N V E R S I O N

    #
    def to_au
      @to_au ||= (
        measures = units.map{ |u| u.to_au }
        Measure.new(value, measures) #.reduce
      )
    end

    #
    def universal
      to_au
      #@universal ||= (
      #  measures = units.map{ |u| u.universal }
      #  Measure.new(value, measures) #.reduce
      #)
    end

    #
    def standard
      @standard ||= (
        measures = units.map{ |u| u.standard }
        Measure.new(value, measures) #.reduce
      )
    end

    #
    def base
      @base ||= (
        measures = units.map{ |u| u.base }
        Measure.new(value, measures) #.reduce
      )
    end
    
    # Convert measure to be quantitized by +goal+ measure.
    # This form of conversion is power and value significant.
    # For example, to convert 1.m^-1 to km, you need to use the
    # same power:
    #
    #   x = 1.m ^ -1
    #   x.to(1.km ^ -1)  # RIGHT!
    #   x.to(1.km)       # WRONG!

    def to(goal)
      case goal
      when Measure
        r = self / goal
        Measure.new(r.value, r.units, goal.units) #.measure)
      when Symbol, System
        measures = units.map{ |u| u.to_system(goal) }
        Measure.new(value, measures) #.reduce
      end
    end

    # Convert a measure to another set of units on a unit-by-unit
    # basis.

    def to_unit(goal_measure)
      # we need a copy of this measures units
      self_units      = units.dup
      # we need the units of the goal measure
      goal_units      = goal_measure.units
      # we need to sort all the units in the measure
      # with types that are commensurate with the goal units.
      matching_units = Hash.new{|h,k|h[k]=[]}
      goal_units.each do |gu|
        units.each do |su|
          if gu.commensurate?(su)
            matching_units[gu] << self_units.delete(su)
          end
        end
      end
      # those that are macthed are converted
      conv_units = matching_units.map do |gu, sus|
        sus.map do |su|
          gu.class.from_universal(su.universal) # power
        end
      end.flatten
      # the new measure combines the converted units, remaning
      # unconverted units and the measures value.
      Measure.new(value, self_units, conv_units)
    end

    # Returns the value if this Measure is unitless, and raises an
    # exception otherwise.

    def to_num
      if unitless? #Units::Value === val
        value
      else
        raise TypeError, "Cannot convert to number"
      end
    end

    # Returns a float if this Measure is unitless, and raises an
    # exception otherwise.

    def to_f
      if unitless? #Units::Value === val
        value.to_f
      else
        raise TypeError, "Cannot convert to float"
      end
    end

    # Returns an int if this Measure is unitless, and raises an
    # exception otherwise.

    def to_i
      if unitless?
        value.to_i
      else
        raise TypeError, "Cannot convert to integer"
      end
    end

    # Returns an int if this Measure is unitless, and raises an
    # exception otherwise.

    def to_int
      if unitless?
        value.to_int
      else
        raise TypeError, "Cannot convert to integer"
      end
    end

    # Returns a human readable string representation.
# TODO
    def to_s
      numerator = ""
      denominator = ""
      units.each do |unit|
        u = unit.symbol
        e = unit.power
        e_abs = e > 0 ? e : -e # This works with Complex too
        (e > 0 ? numerator : denominator) << " #{u.to_s}#{"**#{e_abs}" if e_abs != 1}"
      end
      "#{numerator.lstrip}#{"/" + denominator.lstrip if not denominator.empty?}"
    end

    #

    def inspect
      [value.to_s, *units].join(' ')
    end

    #

    def hash #:nodoc:
      value.hash ^ units.hash
    end


    # O P E R A T I O N S

    # If attempting an operation with a scalar as the reciever
    # and a measure as the message, swap their roles.
    # Note this works for addition and multipliation, but
    # not for division or subtraction, and other non-communative
    # operations (TODO: Any way to fix?).

    def coerce(other)
      return self, other
    end

    # Invert the measure, ie. divide it into 1.

    def invert
      nt = []
      table.each do |u|
        case u
        when Numeric
          nt << (1.0 / u) # TODO: this right?
        else #Unit
          nt << u.invert
        end
      end
      Measure.new(nt)
    end

    # Return a new measure of same units as this current
    # measure, but with a value of 1.

    def normalize
      Measure.new(units)
    end

    #

    def -@ # :nodoc:
      self.class.new(-value, units)
    end

    #

    def +@ # :nodoc:
      self
    end

    # Raise the measure to the given +power+.

    def **(power)
      Measure.new(table.map{ |u| u**power }) #.reduce
    end

    # Raise the units of the measure to a given +power+.
    #
    # NOTE: If only this shared the same precedence as ** :(

    def ^(power)
      Measure.new(value, units.map{ |u| u**power }) #.reduce
    end

    # Return the sum of two measures.

    def +(other)
      if units == other.units
        Measure.new(value + other.value, units)
      else
        if systemic?(other)
          a, b = base, other.base
          raise "incompatible units" if a.units != b.units
          a + b #.to(other)
        else
          a, b = universal, other.universal
          raise "incompatible units" if a.units != b.units
          a + b #.to(other)
        end
      end
    end

    # Return the difference between two measures.

    def -(other)
      if self === other #units == other.units
        Measure.new(value - other.value, units)
      else
        if systemic?(other)
          a, b = base, other.base
          raise "incompatible units" if a.units != b.units
          a + b #.to(other)
        else
          a, b = universal, other.universal
          raise "incompatible units" if a.units != b.units
          a - b #.to(other)
        end
      end
    end

    # Return the product of two measures.

    def *(other)
      case other
      when Measure
        if self === other # eg. idential types
          Measure.new(self, other)
        elsif proportional?(other)
          if systemic?(other)
            Measure.new(base, other.base.invert)
          else
            Measure.new(universal, other.universal.invert) #.to(other)
          end
        else
          Measure.new(self, other) #.reduce
        end
      when Numeric
        1 == other ? self : Measure.new(self, other) #.reduce
      else
        raise ArgumentError
      end
    end

    # Divide one measure from another.

    def /(other)
      case other
      when Measure
        if self === other # eg. idential types
          Measure.new(self, other.invert)
        elsif proportional?(other)
          if systemic?(other)
            Measure.new(base, other.base.invert)
          else
            Measure.new(universal, other.universal.invert)
          end
        else
          Measure.new(self, other.invert)
        end
      when Numeric
        Measure.new(1.0 / other, self)
      else
        raise ArgumentError
      end
    end

    #

    def divmod(other)
      if units == other.units
        value.divmod(other.value)
      else
        if systemic?(other)
          a, b = base, other.base
          raise "incompatible units" if a.units != b.units
          a.value.divmod(b.value)
        else
          a, b = universal, other.universal
          raise "incompatible units" if a.units != b.units
          a.value.divmod(b.value)
        end
      end
    end

    #

    def remainder(other)
      if units == other.units
        value.remainder(other.value)
      else
        if systemic?(other)
          a, b = base, other.base
          raise "incompatible units" if a.units != b.units
          a.value.remainder(b.value)
        else
          a, b = universal, other.universal
          raise "incompatible units" if a.units != b.units
          a.value.remainder(b.value)
        end
      end
    end

    #

    def modulo(other)
      divmod(other).last
    end

    #

    def %(other)
      modulo(other)
    end

    #

    %w{ abs ceil floor next round succ truncate }.each do |op|
      eval %{
        def #{op}
          self.class.new(value.#{op}, units)
        end
      }
    end

    #

    %w{ finite? infinite? integer? nan? nonzero? zero? }.each do |op|
      eval %{
        def #{op}
          value.#{op}
        end
      }
    end

    # This will be useful if unit multiples is ever implemented.

    #def demultiply
    #  v = value
    #  u = []
    #  unit.each do |b|
    #    v = v * b.multiple
    #    u << b.class.new(b.power)
    #  end
    #  Measure.new(v, u)
    #  #@value = v
    #  #@unit  = Unit.new(u)
    #  #self
    #end


    # C O M P A R I S O N S

    # Reduce +self+ and +other+ to their universal measures,
    # if +self+ has all the same unit types as +other+, in less
    # or equal power, then +self+ is a *factor* of +other+.

    def factor?(other)
      these_units = universal.units
      other_units = other.universal.units
      track_units = these_units.dup
      these_units.each do |u|
        track_units.delete(u) if other_units.find do |ou|
          ou === u && (u.power > 0 ? ou.power >= u.power : ou.power <= u.power)
        end
      end
      track_units.empty?
    end

    #def factor?(other)
    #  other_universal_units = other.universal.units
    #  universal = self.universal
    #  universal_units = universal.units.dup
    #  universal.units.each do |bu|
    #    universal_units.delete(bu) if other_universal_units.find do |u| 
    #      u === bu && (bu.power > 0 ? u.power >= bu.power : u.power <= bu.power)
    #    end
    #  end
    #  universal_units.empty?
    #end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the same unit types of +self+, regarless of
    # power, then +self+ and +other+ are *commensurate* measures.

    def commensurate?(other)
      s =  self.universal.unit.map{ |u| u.class }.uniq.sort{ |a,b| a.name <=> b.name }
      o = other.universal.unit.map{ |u| u.class }.uniq.sort{ |a,b| a.name <=> b.name }
      s == o
    end

    # Reduce +self+ and +other+ to their universal base measure,
    # if the +other+ has all the same units in equal power 
    # to +self+, then they are said to be *proportional*
    # measures, i.e. their ratio would produce a unitless number.

    def proportional?(other)
      if systemic?(other)
        s =  self.base.units
        o = other.base.units
      else
        s =  self.base.universal.units
        o = other.base.universal.units
      end
      o == s
    end

    # Are all the units of two measures from the same system?
    # If so return the system, otherwise false.

    def systemic?(other)
      s1 =  self.units.map{ |u| u.system }.uniq
      s2 = other.units.map{ |u| u.system }.uniq
      s = (s1 + s2).uniq
      s.size == 1 ? s.first : false
    end

    # Do two measures have the same units?

    def ===(other)
      case other
      when Measure
        return true if units.sort == other.units.sort
      when Numeric # Number
        return true if units.empty?
      end
      false
    end

    # When reduced to universal measures are two measures
    # the same type and value?

    def ==(other)
      case other
      when Measure
        a =  self.universal
        b = other.universal
        return false unless a.value == b.value
        return false unless a.units.sort == b.units.sort
        return true
      when Numeric # Number
        return true if unitless? && value == other
      end
      false
    end

    #

    def equals?(other)
      case other      
      when Measure
        return false unless value == other.value
        return false unless units.sort == other.units.sort
        return true
      when Numeric
        return true if unitless? && value == other
      end
      false
    end

    #
    #def eql?(other)
    #end

    #

    def <=>(other) # :nodoc:
      if other == 0
        value <=> 0
      else
        (self - other).value <=> 0
      end
    rescue TypeError
      nil
    end

  end

end

