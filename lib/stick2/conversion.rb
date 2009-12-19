require 'stick2/frame'

module Stick
module Units

  #

  class Conversion

    attr :fn

    #
    def initialize(op, *args)
      @fn = [op, *args]
    end

    #
    def to_s
      "#<(#{fn[1]} #{fn[0]} " + fn[2..-1].map{ |e| e.inspect }.join(',') + ')>'
    end

    alias_method :inspect, :to_s

    #

    def *(other)
      Conversion.new(:'*', self, other)
    end

    #

    def /(other)
      Conversion.new(:'/', self, other)
    end

    #

    def **(other)
      Conversion.new(:'**', self, other)
    end

    #

    def coerce(other)
      [self, other]
    end

    #

    def system
      @system ||= (
        list = fn.map do |e|
          case e
          when Type, Conversion
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
        fn.each do |e|
          case e
          when Type, Conversion
            return false unless e.base?
          end
        end
        true
      )
    end

    #

    def call #(measure)
      op, *args = *fn
      receiver, *arguments = args.map do |arg|
        case arg
        when Conversion
          arg.call
        when Type
          Measure.new(Unit.new(arg, 1))
        else
          arg
        end
      end
      unit_measure = receiver.__send__(op, *arguments)
      unit_measure
      #measure.value * unit_measure ** measure.power
    end

  end

end
end

