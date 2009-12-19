require 'facets/module/basename'

#require 'stick2/measure'
#require 'stick2/unit'

#require 'stick2/units/au'
#require 'stick2/units/si'
#require 'stick2/units/us'

module Stick

  #
  #DEFAULT_SYSTEM = Stick::Units::SI #:si

  #
  #def self.setup
  #  self.system(DEFAULT_SYSTEM) # default 

#    Unit.register.each do |base|
#      names = [base.symbol, base.term, base.single].compact.uniq
#      names.each do |name|
#        ::Numeric.class_eval do
#          define_method(name){ Measure.new(self, base.new) }
#        end
#      end
#    end
  #end

end

#Stick.setup

require 'stick2/units'
