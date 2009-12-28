require 'facets/module/basename'

#class Numeric
#  alias_method :^, :**
#end

module Stick
  require 'stick/system'
  require 'stick/unit'
  require 'stick/measure'

  require "stick/units/au/system"
  require "stick/units/si/system"

  #DEFAULT_SYSTEM = Stick::Units::SI #:si
end


