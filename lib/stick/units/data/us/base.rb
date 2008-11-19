require 'si/base'

converter 'us_base' do
  length_unit "inch",          :abbrev => "in",    :equals => "2.54 si_base:cm",                :alias => "inches"
  length_unit "foot",          :abbrev => "ft",    :equals => "12.0 in",                        :alias => "feet"
  length_unit "yard",          :abbrev => "yd",    :equals => "3.0 ft",                         :alias => "yards"
  length_unit "furlong",                           :equals => "220.0 yd",                       :alias => "furlongs"
  length_unit "mile",          :abbrev => "mi",    :equals => "8.0 furlongs",                   :alias => "miles"
  length_unit "acre",                              :equals => "4840.0 sq_yd",                   :alias => "acres"
  unit        "section",                           :equals => "1.0 sq_mi",                      :alias => "sections"
  unit        "township",                          :equals => "36.0 sections",                  :alias => "townships"
  unit        "fluid_ounce",   :abbrev => "fl_oz", :equals => "2.95735295625e-2 si_base:dm**3", :alias => "fluid_ounces"
  unit        "gill",                              :equals => "4.0 fl_oz",                      :alias => "gills"
  unit        "pint",          :abbrev => "pt",    :equals => "4.0 gills",                      :alias => "pints"
  unit        "quart",         :abbrev => "qt",    :equals => "2.0 pt",                         :alias => "quarts"
  unit        "gallon",        :abbrev => "gal",   :equals => "4.0 qt",                         :alias => "gallons"
  unit        "grain",         :abbrev => "gr",    :equals => "6.479891e-5 si_base:kg",         :alias => "grains"
  unit        "ounce",         :abbrev => "oz",    :equals => "437.5 gr",                       :alias => "ounces"
  unit        "pound",         :abbrev => "lb",    :equals => "16.0 oz",                        :alias => "pounds"
  unit        "stone",                             :equals => "14.0 lb",                        :alias => "stones"
  unit        "hundredweight", :abbrev => "cwt",   :equals => "100.0 lb",                       :alias => "hundredweights"
  unit        "short_ton",     :abbrev => "st",    :equals => "20.0 cwt",                       :alias => "short_tons"
end
