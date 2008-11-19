require 'si/base'

converter 'uk_base' do
  length_unit "inch", :abbrev => "in", :equals => "2.54 si_base:cm", :alias => "inches"
  length_unit "foot", :abbrev => "ft", :equals => "12.0 in", :alias => "feet"
  length_unit "yard", :abbrev => "yd", :equals => "3.0 ft", :alias => "yards"
  length_unit "chain", :abbrev => nil, :equals => "22.0 yd", :alias => "chains"
  length_unit "furlong", :abbrev => nil, :equals => "10.0 chains", :alias => "furlongs"
  length_unit "mile", :abbrev => "mi", :equals => "8.0 furlongs", :alias => "miles"
  unit        "acre", :abbrev => nil, :equals => "10 square_chain", :alias => "acres"
  unit        "fluid_ounce", :abbrev => "fl_oz", :equals => "2.8413062e-2 si_base:dm**3", :alias => "fluid_ounces"
  unit        "gill", :abbrev => nil, :equals => "5.0 fl_oz", :alias => "gills"
  unit        "pint", :abbrev => "pt", :equals => "4.0 gills", :alias => "pints"
  unit        "quart", :abbrev => "qt", :equals => "2.0 pt", :alias => "quarts"
  unit        "gallon", :abbrev => "gal", :equals => "4.0 qt", :alias => "gallons"
  unit        "grain", :abbrev => "gr", :equals => "6.479891e-5 si_base:kg", :alias => "grains"
  unit        "ounce", :abbrev => "oz", :equals => "437.5 gr", :alias => "ounces"
  unit        "pound", :abbrev => "lb", :equals => "16.0 oz", :alias => "pounds"
  unit        "stone", :abbrev => nil, :equals => "14.0 lb", :alias => "stones"
  unit        "hundredweight", :abbrev => "cwt", :equals => "8.0 stone", :alias => "hundredweights"
  unit        "long_ton", :abbrev => "lt", :equals => "20.0 cwt", :alias => "long_tons"
end
