require 'facets/module/basename'

require 'stick3/unit'
require 'stick3/measure'
require 'stick3/units/au'
require 'stick3/units/si'

module Stick

  #

  DEFAULT_SYSTEM = Stick::Units::SI #:si

  # Set or get the base system.

  def self.system(sym=nil)
    @system = sym if sym
    @system
  end

  #

  def self.setup
    self.system(DEFAULT_SYSTEM) # default 

    Unit.register.each do |base|
      names = [base.symbol, base.term, base.single].compact.uniq
      names.each do |name|
        ::Numeric.class_eval do
          #define_method(name){ Measure.new(self, base.new(1,1)) }
          # TODO: add power, but needs default of 1
          #define_method(name){ |power| base.new(self, power || 1) } #Measure.new(self, base.new(1,1)) }
          define_method(name){ base.new(self, 1) } #Measure.new(self, base.new(1,1)) }
        end
      end
    end
  end

end

Stick.setup

