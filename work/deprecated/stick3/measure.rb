module Stick

  # Measure is a compound unit.
  #
  class Measure

    class << self
      alias_method :__new__, :new
      private :__new__
    end

    # TODO: convert to single unit type if units are all the one type.
    def self.new(*units)
      __new__(*units)
    end

    #
    def initialize(*units)
      @table = []
      units.flatten.each do |unit|
        case unit
        when Measure
          table.concat(unit.table)
        when Unit
          table << unit
        when Numeric
          table << unit
        else
          raise ArgumentError, "#{unit} is not a valid unit component"
        end
      end
      reduce
    end

    # Sum values and merge common units.
    #
    # TODO: Should this be immutable or private?

    def reduce
      retable = []
      units = table.select{ |u| Unit === u }
      types = units.map{ |u| u.class }.uniq
      group = units.group_by{ |b| b.class }
      types.each do |type|
        units = group[type]
        power = 0; units.each{ |u| power += u.power }
        retable << type.new(1, power) unless power == 0
      end
      @table = [value, *retable]
      self
    end

    #
    def table
      @table
    end

    #
    def value
      table.inject(1){ |v, u| v *= Unit === u ? u.value : u; v }
    end

    #
    def units
      table.select{ |u| Unit === u }
    end

    # C O N V E R S I O N S

    #

    def universal
      Measure.new(value, units.map{ |u| u.universal })
    end

    #

    def standard
      Measure.new(value, units.map{ |u| u.standard })
    end

    #

    def base
      Measure.new(value, units.map{ |u| u.base })
    end

    #

    #def to_au
    #  Measure.new(value, units.map{ |u| u.to_au })
    #end

    # Convert measure to be qunatitized by +goal+ measure.
    # This form of conversion is power and value significant.
    # For example, to convrt 1.m^-1 to km, you need to use the
    # same power:
    #
    #   x = 1.m ^ -1
    #   x.to(1.km ^ -1)  # RIGHT!
    #   x.to(1.km)       # WRONG!

    def to(goal)
      r = self / goal
      self.class.new(r.value, r.units, goal.units) #.measure)
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
          gu.class.from_standard_measure(su.standard_measure) # power
        end
      end.flatten
      # the new measure combines the converted units, remaning
      # unconverted units and the measures value.
      Measure.new(value, self_units, conv_units)
    end

    # TODO: Improve

    def to_s
      [value, *units.map{ |u| u.to_s.sub("1 ",'') } ].join(' ')
    end

    #

    alias_method :inspect, :to_s


    # C O M P A R I S O N S

    # Reduce +self+ and +other+ to their universal measures,
    # if +self+ has all the same unit types as +other+, in less
    # or equal power, then +self+ is a *factor* of +other+.

    def factor?(other)
      these_units = universal.units
      other_units = other.univeral.units
      track_units = these_units.dup
      these_units.each do |u|
        track_units.delete(u) if other_units.find do |ou|
          ou === u && (u.power > 0 ? ou.power >= u.power : ou.power <= u.power)
        end
      end
      track_units.empty?
    end

    # Reduce +self+ and +other+ to their universal measures,
    # if +other+ has all the same unit types of +self+, regarless
    # of power, then +self+ and +other+ are *commensurate* measures.

    def commensurate?(other)
      s =  self.universal.units.map{ |u| u.class }.uniq.sort{ |a,b| a.name <=> b.name }
      o = other.universal.units.map{ |u| u.class }.uniq.sort{ |a,b| a.name <=> b.name }
      s == o
    end

    # Reduce +self+ and +other+ to their universal measures,
    # if the +other+ has all the same units in equal power 
    # to +self+, then they are said to be *proportional*
    # measures, i.e. their ratio would produce a unitless number.

    def proportional?(other)
      s =  self.universal.reduce.units.sort #.map{ |u| u.class }
      o = other.universal.reduce.units.sort #.map{ |u| u.class }
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
        return false unless units.sort == other.units.sort
      else # Number
        return false unless units.empty?
      end
      true
    end

    # When reduced to base measures are two measures
    # the same type and value?

    def ==(other)
      a =  self.base
      b = other.base
      return false unless a.value == b.value
      return false unless b.units.sort == b.units.sort
      return true
    end

    #
    def equals?(other)
      return false unless value == other.value
      return false unless units.sort == other.units.sort
      return true
    end

    #
    #def eql?(other)
    #end


    # O P E R A T I O N S

    # If attempting an operation with a scalar as the reciever
    # and a measure as the message, swap their roles.
    # Note this works for addition and multipliation, but
    # not for division or subtraction, and other non-communative
    # operations (TODO: Any way to fix?).

    def coerce(other)
      return self, other
    end

    # Raise the measure to the given +power+.

    def **(power)
      self.class.new(table.map{ |u| u**power }) #.reduce
    end

    # Raise the units of the measure to a given +power+.
    #
    # NOTE: If only this shared the same precedence as #** !!! :(

    def ^(power)
      self.class.new(value, units.map{ |u| u**power }) #.reduce
    end

    #

    def +(other)
      if units == other.units
        Measure.new(value + other.value, units)
      elsif units.systemic?(other.units)
        a, b = base, other.base
        raise "incompatible units" if a.units != b.units
        r = a + b
      else
        a, b = universal, other.universal
        raise "incompatible units" if a.units != b.units
        r = a + b
        r.to(other)
      end      
    end

    #

    def -(other)
      if units == other.units
        Measure.new(value - other.value, units)
      elsif units.systemic?(other.units)
        a, b = base, other.base
        raise "incompatible units" if a.units != b.units
        r = a - b
      else
        a, b = universal, other.universal
        raise "incompatible units" if a.units != b.units
        r = a - b
        r.to(other)
      end      
    end

    #

    def *(other)
      #if units == other.units
      #  Measure.new(value * other.value, units.map{|u| u.normalize})
      if systemic?(other)
        a, b = base, other.base
        Measure.new(self, other)
      else
        #a, b = universal, other.universal
        Measure.new(self, other)
        #r.to(other)
      end      
    end

    #

    def /(other)
      #if units == other.units
      #  Measure.new(value * other.value**-1, units.map{|u| u.normalize})
      if systemic?(other)
        a, b = base, other.base
        Measure.new(self, other**-1)
      else
        #a, b = universal, other.universal
        Measure.new(self, other**-1)
        #r.to(other)
      end      
    end

    #

    def %(other)
    end

    # Return a new measure of same units as this current
    # measure, but with a value of 1.

    def normalize
      self.class.new(units.map{ |u| u.normalize })
    end

    # Invert the measure, ie. divide it into 1.

    def invert
      t = []
      table.each do |u|
        case u
        when Numeric
          t << (1.0 / u) # TODO: this right?
        else #Unit
          t << u.invert
        end
      end
      self.class.new(t)
    end

  end

end

