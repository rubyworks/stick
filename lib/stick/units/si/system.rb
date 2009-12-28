module Stick

  # SI Metric conversions
  c = 299792458.0     # m / s
  g = 6.67428e-11     # m3 kg-1 s-2
  h = 6.62606896e-34  # m2 kg / s
  u = 1.25663706e-6   # N / A2
  k = 1.3806504e-23   # J / K

  system :si, [c, g, h, u, k]

end

require 'stick/units/si/prefixes'
require 'stick/units/si/units'
require 'stick/units/si/conversions'
#require 'stick/units/si/constants'
