module Stick

  # A compound of base units.
  class UnitOfMeasure

    include Enumerable

    attr :units

    # A unit is a compound of base units.
    def initialize(*units)
      @units = units.flatten.map{ |u|
        self.class === u ? u.units : u
      }.flatten
    end

    #
    def initialize_copy(orig)
      @units = orig.units.dup
    end

    #  
    def each(&block)
      units.each(&block)
    end

    #
    def size
      units.size
    end

    #
    def to_base
      #u = units.map{ |um| um.to_base.unit }
      #Measure.new(1, *u)
      measures = units.map{ |base| base.to_base }

    end

    #def to_lcu
    #  u = units.map{ |um| um.to_base.unit }
    #  self.class.new(*u)
    #end

    #
    def invert
      self.class.new(*units.map{ |um| um.invert })
    end

    #
    def to_s
      units.map{ |um| um.to_s }.join(" ")
    end

    #
    alias_method :inspect, :to_s

    #
    def ==(other)
      units.sort == other.units.sort
    end

#
#    def ===(other)
#p to_lcu
#p other.to_lcu
#      to_lcu == other.to_lcu
#    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, in less
    # or equal power, then +self+ is a *factor* of the +other+ unit.

    def factor?(other)
      s =  self.to_base.unit.map{ |u| [u.class] * u.power }.flatten
      o = other.to_base.unit.map{ |u| [u.class] * u.power }.faltten
      (s - o).empty?
    end

    # Reduce +self+ and +other+ to their least common measures,
    # if +other+ has all the base unit classes of +self+, indifferent
    # of their power, then they are said to be *commensurate* units.

    def commensurate?(other)
      s =  self.to_base.unit.map{ |u| u.class }.uniq
      o = other.to_base.unit.map{ |u| u.class }.uniq
      (s - o).empty? && (o - s).empty?
    end

    # Reduce +self+ and the +other+ unit to their least comon
    # measures, if the +other+ has all the same unit classes
    # in equal power as +self+, then they are said to be
    # *proportional* units, i.e. their ratio would produce
    # a unitless number.

    def proportional?(other)
      #s =  self.to_base.unit.map{ |u| u.class }
      #o = other.to_base.unit.map{ |u| u.class }
      s =  self.unit.map{ |b| b.to_base.unit.map{ |u| u.class }}.flatten.uniq
      o = other.unit.map{ |b| b.to_base.unit.map{ |u| u.class }}.flatten.uniq
      (o - s).empty? && (s - o).empty?
    end

    #
    def **(number)
      UnitOfMeasure.new(*units.map{ |u| u**number })
    end

    #
    def common(other)
      ru = to_lcu.to_a
      nu = []
      other.each do |u|
        ni = []
        u.to_lcu.each do |l|
          i = ru.index(l)
          ni << ru[i]
          ru.delete_at(i)
        end
        nu << ni
      end
      return nu #, ru  # matches, remainder
    end

    #
    def unit ; self ; end


  end

end

