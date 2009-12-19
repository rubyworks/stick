module Stick
module Units

  #
  class SpeedOfLight < Constant

    TERMS  = [:speed_of_light, :lightspeed]

    SYMBOL = :c

    #
    def to_au
      Measure.new(At / As, AU::Space**1, AU::Time**-1)
      #au_ratio(1, -1)
    end

  end

end
end
