# Title:
#
#   Unitless CGS Constants
#
# Copyright:
#
#   Copyright (C) 2003 Daniel Carrera, Brian Gough
#
#   MIT License
#
# Authors:
#
#   - Daniel Carrera
#   - Brian Gough
#   - Thomas Sawyer

module Stick #:nodoc:
module Constants
module Typeless

  # Unitless Constants in the CGS system (cm, kg, s)

  module CGS
    SPEED_OF_LIGHT           = 2.99792458e10     # cm / s
    GRAVITATIONAL_CONSTANT   = 6.673e-8   # cm^3 / g s^2
    PLANCKS_CONSTANT_H       = 6.62606876e-27 # g cm^2 / s
    PLANCKS_CONSTANT_HBAR    = 1.05457159642e-27 # g cm^2 / s
    VACUUM_PERMEABILITY      = 1.25663706144e-1 # cm g / A^2 s^2
    ASTRONOMICAL_UNIT        = 1.49597870691e13 # cm
    LIGHT_YEAR               = 9.46053620707e17   # cm
    PARSEC                   = 3.08567758135e18   # cm
    GRAV_ACCEL               = 9.80665e2 # cm / s^2
    ELECTRON_VOLT            = 1.602176462e-12 # g cm^2 / s^2
    MASS_ELECTRON            = 9.10938188e-28 # g
    MASS_MUON                = 1.88353109e-25 # g
    MASS_PROTON              = 1.67262158e-24 # g
    MASS_NEUTRON             = 1.67492716e-24 # g
    RYDBERG                  = 2.17987190389e-11 # g cm^2 / s^2
    BOLTZMANN                = 1.3806503e-16   # g cm^2 / K s^2
    BOHR_MAGNETON            = 9.27400899e-20  # A cm^2
    NUCLEAR_MAGNETON         = 5.05078317e-23 # A cm^2
    ELECTRON_MAGNETIC_MOMENT = 9.28476362e-20 # A cm^2
    PROTON_MAGNETIC_MOMENT   = 1.410606633e-22  # A cm^2
    MOLAR_GAS                = 8.314472e7      # g cm^2 / K mol s^2
    STANDARD_GAS_VOLUME      = 2.2710981e4 # cm^3 / mol
    MINUTE                   = 6e1     # s
    HOUR                     = 3.6e3   # s
    DAY                      = 8.64e4  # s
    WEEK                     = 6.048e5 # s
    INCH                     = 2.54e0  # cm
    FOOT                     = 3.048e1 # cm
    YARD                     = 9.144e1 # cm
    MILE                     = 1.609344e5 # cm
    NAUTICAL_MILE            = 1.852e5    # cm
    FATHOM                   = 1.8288e2   # cm
    MIL                      = 2.54e-3    # cm
    POINT                    = 3.52777777778e-2 # cm
    TEXPOINT                 = 3.51459803515e-2 # cm
    MICRON                   = 1e-4    # cm
    ANGSTROM                 = 1e-8    # cm
    HECTARE                  = 1e8     # cm^2
    ACRE                     = 4.04685642241e7 # cm^2
    BARN                     = 1e-24   # cm^2
    LITER                    = 1e3     # cm^3
    US_GALLON                = 3.78541178402e3 # cm^3
    QUART                    = 9.46352946004e2 # cm^3
    PINT                     = 4.73176473002e2 # cm^3
    CUP                      = 2.36588236501e2 # cm^3
    FLUID_OUNCE              = 2.95735295626e1 # cm^3
    TABLESPOON               = 1.47867647813e1 # cm^3
    TEASPOON                 = 4.92892159375e0 # cm^3
    CANADIAN_GALLON          = 4.54609e3  # cm^3
    UK_GALLON                = 4.546092e3 # cm^3
    MILES_PER_HOUR           = 4.4704e1   # cm / s
    KILOMETERS_PER_HOUR      = 2.77777777778e1 # cm / s
    KNOT                     = 5.14444444444e1 # cm / s
    POUND_MASS               = 4.5359237e2    # g
    OUNCE_MASS               = 2.8349523125e1 # g
    TON                      = 9.0718474e5    # g
    METRIC_TON               = 1e6     # g
    UK_TON                   = 1.0160469088e6 # g
    TROY_OUNCE               = 3.1103475e1    # g
    CARAT                    = 2e-1    # g
    UNIFIED_ATOMIC_MASS      = 1.66053873e-24 # g
    GRAM_FORCE               = 9.80665e2          # cm g / s^2
    POUND_FORCE              = 4.44822161526e5    # cm g / s^2
    KILOPOUND_FORCE          = 4.44822161526e8    # cm g / s^2
    POUNDAL                  = 1.38255e4  # cm g / s^2
    CALORIE                  = 4.1868e7   # g cm^2 / s^2
    BTU                      = 1.05505585262e10 # g cm^2 / s^2
    THERM                    = 1.05506e15 # g cm^2 / s^2
    HORSEPOWER               = 7.457e9    # g cm^2 / s^3
    BAR                      = 1e6        # g / cm s^2
    STD_ATMOSPHERE           = 1.01325e6  # g / cm s^2
    TORR                     = 1.33322368421e3  # g / cm s^2
    METER_OF_MERCURY         = 1.33322368421e6 # g / cm s^2
    INCH_OF_MERCURY          = 3.38638815789e4  # g / cm s^2
    INCH_OF_WATER            = 2.490889e3 # g / cm s^2
    PSI                      = 6.89475729317e4 # g / cm s^2
    POISE                    = 1e0      # g / cm s
    STOKES                   = 1e0      # cm^2 / s
    FARADAY                  = 9.6485341472e4  # A s / mol
    ELECTRON_CHARGE          = 1.602176462e-19 # A s
    GAUSS                    = 1e-1     # g / A s^2
    STILB                    = 1e0      # cd / cm^2
    LUMEN                    = 1e0      # cd sr
    LUX                      = 1e-4     # cd sr / cm^2
    PHOT                     = 1e0      # cd sr / cm^2
    FOOTCANDLE               = 1.076e-3 # cd sr / cm^2
    LAMBERT                  = 1e0      # cd sr / cm^2
    FOOTLAMBERT              = 1.07639104e-3 # cd sr / cm^2
    CURIE                    = 3.7e10   # 1 / s
    ROENTGEN                 = 2.58e-7  # A s / g
    RAD                      = 1e2      # cm^2 / s^2
    SOLAR_MASS               = 1.98892e33 # g
    BOHR_RADIUS              = 5.291772083e-9 # cm
    VACUUM_PERMITTIVITY      = 8.854187817e-21 # A^2 s^4 / g cm^3
    NEWTON                   = 1e5     # cm g / s^2
    DYNE                     = 1e0     # cm g / s^2
    JOULE                    = 1e7     # g cm^2 / s^2
    ERG                      = 1e0     # g cm^2 / s^2
  end

end
end
end
