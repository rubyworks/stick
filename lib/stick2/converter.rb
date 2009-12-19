module Stick
module Units

  def self.types;
    @types ||= []
  end

  def self.unit(name, symbol, type)
    system, name = *name.split(':')
    types << Type.new(system, name, :symbol => symbol, :type => type )
  end




  # The Converter class handles the Measure#to method.
  # It's methods are dynamically defined by the
  # base units.

  class Converter

    def ft(measure)
      
    end

  end

end
end

