module Stick
module Units
module AU

  # = Univeral Space
  #
  class Space < AU::Unit
    include Base

    SYMBOL = 'S'

    TYPE   = :space  # instead of length

    # TODO: Can we define methods like this to help accerlerate and improve conversions?
    #def to_si
    #  Measure.new(1/AU::Sa, Meter.new(power))
    #end

  end

end
end
end

