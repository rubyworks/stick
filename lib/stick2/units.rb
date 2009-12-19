require 'stick2/system'
require 'stick2/unit'
require 'stick2/measure'

# load types

require 'stick2/units/au/types'
require 'stick2/units/si/types'

# load conversions

require 'stick2/units/au/conversions'
require 'stick2/units/si/conversions'

# setup numeric

Stick::Units.systems.each do |k, s|
  ::Numeric.class_eval do
    include s.numeric_module
  end
end
