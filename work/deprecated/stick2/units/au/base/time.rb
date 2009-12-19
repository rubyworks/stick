module Stick
module Units
module AU

  # = Universal Time
  #
  class Time < AU::Unit
    include Base

    SYMBOL = 'T'

    TYPE   = :time

    #
    #def to_si
    #  Measure.new(1/AU::Ta, Second.new(power))
    #end

  end

end
end
end

