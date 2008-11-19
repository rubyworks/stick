require 'si/derived'

converter "si_extra" do
  unit "minute",                   :abbrev => "min", :equals => "60.0 si_base:s",                    :alias => "minutes"
  unit "hour",                     :abbrev => "h",   :equals => "60.0 min",                          :alias => "hours"
  unit "day",                      :abbrev => "d",   :equals => "24.0 h",                            :alias => "days"
  unit "liter",                    :abbrev => "L",   :equals => "si_base:dm**3",                     :alias => "liters"
  unit "neper",                    :abbrev => "Np",  :equals => "",                                  :alias => "nepers"
  unit "electronvolt",             :abbrev => "eV",  :equals => "1.60218e-19 si_derived:J",          :alias => "electronvolts"
  unit "are",                      :abbrev => "a",   :equals => "si_base:dam**2",                    :alias => "ares"
  unit "hectare",                  :abbrev => "ha",  :equals => "si_base:hm**2",                     :alias => "hectares"
  unit "barn",                                       :equals => "100.0 si_base:fm**2",               :alias => "barns"
  unit "curie",                    :abbrev => "Ci",  :equals => "3.7e10 si_derived:Bq",              :alias => "curies"
  unit "roentgen",                 :abbrev => "R",   :equals => "2.58e-4 si_base:kg",                :alias => "roentgens"
  unit "metric_ton",               :abbrev => "t",   :equals => "1000.0 si_base:kg",                 :alias => "metric_tons"
  unit "degree",                                     :equals => "0.0174532925199433 si_derived:rad", :alias => "degrees"
  unit "nautical_mile",                              :equals => "1852.0 si_base:m",                  :alias => "nautical_miles"
  unit "knot",                                       :equals => "nautical_mile / h",                 :alias => "knots"
  unit "angstrom",                                   :equals => "100.0 si_derived:kPa",              :alias => "angstroms"
  unit "unified_atomic_mass_unit", :abbrev => "u",   :equals => "1.66054e-27 si_base:kg",            :alias => "unified_atomic_mass_units"
  unit "astronomical_unit",        :abbrev => "ua",  :equals => "1.49598e11 si_base:m",              :alias => "astronomical_units"
end
