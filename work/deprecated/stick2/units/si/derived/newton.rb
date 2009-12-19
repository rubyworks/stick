module Stick
module Units
module SI

  class Newton < AU::Unit

    SYMBOL = :N

    TYPE   = :force

    # AU conversion ratio
    FACTOR = (AU::Ma * AU::Sa / AU::Ta)

    # kg m s-1

    def base
      Measure.new(Kilogram.new, Meter.new, Second.new(-1))
    end

    #

    def self.from_base(measure)
      mesaure = measure.base
      raise unless measure.proportional?(1.N) #FIXME
      Measure.new(measure.value, Newton.new)
    end

    #
 
    def to_au
      Measure.new(1/FACTOR, AU::Force.new(power))
    end

    #

    def self.from_au(measure)
      measure = measure.to_au
      power = measure.pure?(AU::Force)
      raise ArgumentError unless power
      Measure.new(FACTOR * measure.value, new(power))
    end



=begin
    #
    def standard
      #m = self
      # need collection of all base measure in the system
      system_units = Stick::Unit.register.select{ |u| Stick.system == u.system }

      if sametype = system_units.find{ |u| u.type == type }
        Measure.new(sametype.new)
      else
 
        base_units = system_units.select{ |u| u.base? }
        #base_measures = base_units.map{ |u| u.new }
  #silly_measure = Measure.new(base_measures)
  #p silly_measure
        m = standard_measure
        base_units.each do |unit|
          m = m.to_unit(Measure.new(unit.new))
        end
        m
      end
    end
=end

  end

end
end
end

