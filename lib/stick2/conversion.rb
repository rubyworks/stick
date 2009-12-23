require 'stick2/frame'

module Stick
module Units

  # The Conversion class codifies the procedure
  # of calculating a conversion from one unit
  # to a measure of others.
  #
  #--
  # TODO: I suspect this design may submit to greater simplification
  # perhaps by having it produce a reduced Proc, thus allowing us
  # dispense with the Conversion object itself.
  #++
  class Conversion

    attr :fn

    #
    def initialize(op, *args)
      @fn = [op, *args]
    end

    #
    def to_s
      '#<' + @fn.inspect + ')>'
    end

    alias_method :inspect, :to_s

    #

    def +(other)
      #other = other.fn if Conversion===other
      @fn = [:'+', @fn, other]
      self
    end

    #

    def -(other)
      #other = other.fn if Conversion===other
      #Conversion.new(:'-', self, other)
      @fn = [:'-', @fn, other]
      self
    end

    #

    def *(other)
      #other = other.fn if Conversion===other
      #Conversion.new(:'*', self, other)
      @fn = [:'*', @fn, other]
      self
    end

    #

    def /(other)
      #other = other.fn if Conversion===other
      #Conversion.new(:'/', self, other)
      @fn = [:'/', @fn, other]
      self
    end

    #

    def **(other)
      #other = other.fn if Conversion===other
      #Conversion.new(:'**', self, other)
      @fn = [:'**', @fn, other]
      self
    end

    #

    def coerce(other)
      [self, other]
    end

    #

    def system
      @system ||= (
        list = fn.flatten.map do |e|
          case e
          when UnitType, Conversion
            e.system
          end
        end
        list = list.flatten.compact.uniq
        list.size == 1 ? list.first : list
      )
    end

    #

    def base?
      @base ||= (
        fn.flatten.each do |e|
          case e
          when UnitType, Conversion
            return false unless e.base?
          end
        end
        true
      )
    end

    #

    def call #(measure)
      calc(*fn)
      #op, *args = *fn
      #receiver, *arguments = args.map do |arg|
      #  case arg
      #  when Array
      #    calc(*arg)
      #  when Conversion
      #    arg.call
      #  when UnitType
      #    Measure.new(Unit.new(arg, 1))
      #  else
      #    arg
      #  end
      #end
      #unit_measure = receiver.__send__(op, *arguments)
#p unit_measure
#      unit_measure
      #measure.value * unit_measure ** measure.power
    end

    #
    def calc(op, a, b)
      a = a.fn if Conversion===a
      b = b.fn if Conversion===b
      a = calc(*a) if Array===a
      b = calc(*b) if Array===b
      a = Measure.new(Unit.new(a, 1)) if UnitType===a
      b = Measure.new(Unit.new(b, 1)) if UnitType===b
      a.__send__(op, b)
    end

  end

end
end

