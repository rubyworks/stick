# TITLE:
#
#   Constants MKS
#
# COPYRIGHT:
#
#   Copyright (C) 2007 Stick Development Team
#
#   MIT License
#
# AUTHORS:
#
#   - Thomas Sawyer
#   - Daniel Carrera
#   - Brian Gough

require 'stick/units'

module Stick
module Constants

    # = Constants in the MKS system (meters, kg, sec)
    #
    # Large assortment of real world contants in standard m kg s types.
    # The constants are stored in the Math::Constants::KMS module,
    # but this is included in Math for direct use by other Math libraries.
    #
    # == Synopsis
    #
    #   Math::SPEED_OF_LIGHT                        #=> 2.99792458e8 m/s
    #   Stick::Constants::SPEED_OF_LIGHT            #=> 2.99792458e8 m/s
    #   Stick::Constants::MKS::SPEED_OF_LIGHT       #=> 2.99792458e8 m/s

    module MKS
      include Units

      SPEED_OF_LIGHT           = 2.99792458e8.m/s                       # m / s
      GRAVITATIONAL_CONSTANT   = 6.673e-11.m**3/kg*s**2                 # m^3 / kg s^2
      PLANCKS_CONSTANT_H       = 6.62606876e-34.kg*m**2/s               # kg m^2 / s
      PLANCKS_CONSTANT_HBAR    = 1.05457159642e-34.kg*m**2/s            # kg m^2 / s
      VACUUM_PERMEABILITY      = 1.25663706144e-6.kg*m/A**2*s**2        # kg m / A^2 s^2
      ASTRONOMICAL_UNIT        = 1.49597870691e11.m                     # m
      LIGHT_YEAR               = 9.46053620707e15.m                     # m
      PARSEC                   = 3.08567758135e16.m                     # m
      GRAV_ACCEL               = 9.80665e0.m/s**2                       # m / s^2
      ELECTRON_VOLT            = 1.602176462e-19.kg*m**2/s**2           # kg m^2 / s^2
      MASS_ELECTRON            = 9.10938188e-31.kg                      # kg
      MASS_MUON                = 1.88353109e-28.kg                      # kg
      MASS_PROTON              = 1.67262158e-27.kg                      # kg
      MASS_NEUTRON             = 1.67492716e-27.kg                      # kg
      RYDBERG                  = 2.17987190389e-18.kg*m**2/s**2         # kg m^2 / s^2
      BOLTZMANN                = 1.3806503e-23.kg*m**2/K*s**2           # kg m^2 / K s^2
      BOHR_MAGNETON            = 9.27400899e-24.A*m**2                  # A m^2
      NUCLEAR_MAGNETON         = 5.05078317e-27.A*m**2                  # A m^2
      ELECTRON_MAGNETIC_MOMENT = 9.28476362e-24.A*m**2                  # A m^2
      PROTON_MAGNETIC_MOMENT   = 1.410606633e-26.A*m**2                 # A m^2
      MOLAR_GAS                = 8.314472e0.kg*m**2/K*mol*s**2          # kg m^2 / K mol s^2
      STANDARD_GAS_VOLUME      = 2.2710981e-2.m**3/mol                  # m^3 / mol
      MINUTE                   = 6e1.s                                  # s
      HOUR                     = 3.6e3.s                                # s
      DAY                      = 8.64e4.s                               # s
      WEEK                     = 6.048e5.s                              # s
      INCH                     = 2.54e-2.m                              # m
      FOOT                     = 3.048e-1.m                             # m
      YARD                     = 9.144e-1.m                             # m
      MILE                     = 1.609344e3.m                           # m
      NAUTICAL_MILE            = 1.852e3.m                              # m
      FATHOM                   = 1.8288e0.m                             # m
      MIL                      = 2.54e-5.m                              # m
      POINT                    = 3.52777777778e-4.m                     # m
      TEXPOINT                 = 3.51459803515e-4.m                     # m
      MICRON                   = 1e-6.m                                 # m
      ANGSTROM                 = 1e-10.m                                # m
      HECTARE                  = 1e4.m**2                               # m^2
      ACRE                     = 4.04685642241e3.m**2                   # m^2
      BARN                     = 1e-28.m**2                             # m^2
      LITER                    = 1e-3.m**3                              # m^3
      US_GALLON                = 3.78541178402e-3.m**3                  # m^3
      QUART                    = 9.46352946004e-4.m**3                  # m^3
      PINT                     = 4.73176473002e-4.m**3                  # m^3
      CUP                      = 2.36588236501e-4.m**3                  # m^3
      FLUID_OUNCE              = 2.95735295626e-5.m**3                  # m^3
      TABLESPOON               = 1.47867647813e-5.m**3                  # m^3
      TEASPOON                 = 4.92892159375e-6.m**3                  # m^3
      CANADIAN_GALLON          = 4.54609e-3.m**3                        # m^3
      UK_GALLON                = 4.546092e-3.m**3                       # m^3
      MILES_PER_HOUR           = 4.4704e-1.m/s                          # m / s
      KILOMETERS_PER_HOUR      = 2.77777777778e-1.m/s                   # m / s
      KNOT                     = 5.14444444444e-1.m/s                   # m / s
      POUND_MASS               = 4.5359237e-1.kg                        # kg
      OUNCE_MASS               = 2.8349523125e-2.kg                     # kg
      TON                      = 9.0718474e2.kg                         # kg
      METRIC_TON               = 1e3.kg                                 # kg
      UK_TON                   = 1.0160469088e3.kg                      # kg
      TROY_OUNCE               = 3.1103475e-2.kg                        # kg
      CARAT                    = 2e-4.kg                                # kg
      UNIFIED_ATOMIC_MASS      = 1.66053873e-27.kg                      # kg
      ATOMIC_MASS              = 1.66053873e-27.kg                      # kg
      GRAM_FORCE               = 9.80665e-3.kg*m/s**2                   # kg m / s^2
      POUND_FORCE              = 4.44822161526e0.kg*m/s**2              # kg m / s^2
      KILOPOUND_FORCE          = 4.44822161526e3.kg*m/s**2              # kg m / s^2
      POUNDAL                  = 1.38255e-1.kg*m/s**2                   # kg m / s^2
      CALORIE                  = 4.1868e0.kg*m**2/s**2                  # kg m^2 / s^2
      BTU                      = 1.05505585262e3.kg*m**2/s**2           # kg m^2 / s^2
      THERM                    = 1.05506e8.kg*m**2/s**2                 # kg m^2 / s^2
      HORSEPOWER               = 7.457e2.kg*m**2/s**3                   # kg m^2 / s^3
      BAR                      = 1e5.kg/m*s**2                          # kg / m s^2
      STD_ATMOSPHERE           = 1.01325e5.kg/m*s**2                    # kg / m s^2
      TORR                     = 1.33322368421e2.kg/m*s**2              # kg / m s^2
      METER_OF_MERCURY         = 1.33322368421e5.kg/m*s**2              # kg / m s^2
      INCH_OF_MERCURY          = 3.38638815789e3.kg/m*s**2              # kg / m s^2
      INCH_OF_WATER            = 2.490889e2.kg/m*s**2                   # kg / m s^2
      PSI                      = 6.89475729317e3.kg/m*s**2              # kg / m s^2
      POISE                    = 1e-1.kg*m**-1*s**-1                    # kg m^-1 s^-1
      STOKES                   = 1e-4.m**2/s                            # m^2 / s
      FARADAY                  = 9.6485341472e4.A*s/mol                 # A s / mol
      ELECTRON_CHARGE          = 1.602176462e-19.A*s                    # A s
      GAUSS                    = 1e-4.kg/A*s**2                         # kg / A s^2
      STILB                    = 1e4.cd/m**2                            # cd / m^2
      LUMEN                    = 1e0.cd*sr                              # cd sr
      LUX                      = 1e0.cd*sr/m**2                         # cd sr / m^2
      PHOT                     = 1e4.cd*sr/m**2                         # cd sr / m^2
      FOOTCANDLE               = 1.076e1.cd*sr/m**2                     # cd sr / m^2
      LAMBERT                  = 1e4.cd*sr/m**2                         # cd sr / m^2
      FOOTLAMBERT              = 1.07639104e1.cd*sr/m**2                # cd sr / m^2
      CURIE                    = 3.7e10/1.s                             # 1 / s
      ROENTGEN                 = 2.58e-4.A*s/kg                         # A s / kg
      RAD                      = 1e-2.m**2/s**2                         # m^2 / s^2
      SOLAR_MASS               = 1.98892e30.kg                          # kg
      BOHR_RADIUS              = 5.291772083e-11.m                      # m
      VACUUM_PERMITTIVITY      = 8.854187817e-12.A**2*s**4/kg*m**3      # A^2 s^4 / kg m^3
      NEWTON                   = 1e0.kg*m/s**2                          # kg m / s^2
      DYNE                     = 1e-5.kg*m/s**2                         # kg m / s^2
      JOULE                    = 1e0.kg*m**2/s**2                       # kg m^2 / s^2
      ERG                      = 1e-7.kg*m**2/s**2                      # kg m^2 / s^2
    end

end
end

module Math
  include Stick::Constants::MKS
end
