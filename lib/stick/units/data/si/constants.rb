require 'si/extra'

# TODO: Some of these arn't natural constants, and should be put in a separate converter.

converter "si_constants" do
  unit :gravitational_constant, :G  do "6.673e-11 si_base::m**3 / si_base:kg si_base:s**2" end

  # TODO: name? earth_nominal_gravity
  #unit :gravitational_acceleration               = 9.80665e0.m/s**2                       # m / s^2

  unit(:lightspeed, :c, :speed_of_light){ "2.99792458e8 si_base:m / si_base:s" }

  unit :lightyear                  do "9.46053620707e15 si_base:m" end

  #unit :astronomical_unit, :au    do "1.49597870691e11 si_base:m" end
  unit :parsec                     do "3.08567758135e16 si_base:m" end

  unit :planks_constant, :h        do "6.62606876e-34 si_base:kg si_base:m**2 / si_base:s"    end
  unit :planks_constant_bar, :hbar do "1.05457159642e-34 si_base:kg si_base:m**2 / si_base:s" end

  unit :vacuum_permeability        do "1.25663706144e-6 si_base:kg si_base:m / si_base:A**2 * si_base:s**2" end
  unit :vacuum_permittivity        do "8.854187817e-12 A**2 s**4 / kg m**3" end

  #unit :electronvolt, :eV         do "1.602176462e-19 si_derived:J" end
  unit :electroncharge             do "1.602176462e-19 A * s" end

  unit "electronmass"              do "9.10938188e-31 kg" end
  unit "muonmass"                  do "1.88353109e-28 kg" end
  unit "protonmass"                do "1.67262158e-27 kg" end
  unit "neutronmass"               do "1.67492716e-27 kg" end

  unit "rydberg"                   do "2.17987190389e-18 kg * m**2 / s**2" end
  unit "boltzmann"                 do "1.3806503e-23 kg m**2 / K s**2" end

  unit "bohr_magneton"             do "9.27400899e-24  A m**2" end
  unit "nuclear_magneton"          do "5.05078317e-27  A m**2" end
  unit :electron_magnetic_moment   do "9.28476362e-24  A m**2" end
  unit :proton_magnetic_moment     do "1.410606633e-26 A m**2" end

  unit :bohr_radius, [], "bohr_radii" do "5.291772083e-11 m"   end

  #unit :unified_atomic_mass,      "1.66053873e-27 si_base:kg", :abbrev => "u"
  #unit :atomic_mass               "1.66053873e-27 si_base:kg"
  #unit :angstrom,                 "100.0 si_derived:kPa"

  unit :molar_gas           do "8.314472e0 kg m**2 / K mol s**2" end
  unit :standard_gas_volume do "2.2710981e-2 m**3 / mol"         end

  unit :solar_mass   do "1.98892e30 kg"      end

  unit :carat        do "2e-4 si_base:kg"    end

  unit :fathom       do "1.8288e0 m"         end
  unit :mil          do "2.54e-5 m"          end
  unit :point        do "3.52777777778e-4 m" end
  unit :texpoint     do "3.51459803515e-4 m" end

  unit :micron       do "1e-6 m" end

  unit :ton          do "9.0718474e2 kg"     end
  unit :troy_ounce   do "3.1103475e-2 kg"    end

  unit :gram_force   do "9.80665e-3 kg m / s**2"         end
  unit :poundal      do "1.38255e-1 kg m / s**2"         end
  unit :calorie      do "4.1868e0 kg m**2 / s**2"        end
  unit :btu          do "1.05505585262e3 kg m**2 / s**2" end
  unit :therm        do "1.05506e8 kg m**2 / s**2"       end

  unit :horsepower           do "7.457e2 kg m**2 / s**3"      end
  unit :standard_atmosphere  do "1.01325e5 kg / m s**2"       end
  unit :torr                 do "1.33322368421e2 kg / m s**2" end
  unit :meter_of_mercury     do "1.33322368421e5 kg / m s**2" end

  unit :poise        do "1e-1 kg m**-1 s**-1"     end
  unit :stokes       do "1e-4 m**2 / s"            end
  unit :faraday      do "9.6485341472e4 A s / mol" end

  unit :stilb        do "1e4 cd / m**2"             end                # cd / m^2
  unit :phot         do "1e4 cd * sr / m**2"        end                # cd sr / m^2
  #unit :lumen       do "1e0 cd * sr"               end                # cd sr
  #unit :lux         do "1e0 cd * sr / m**2"        end                # cd sr / m^2

  unit :dyne         do "1e-5 kg m / s**2"    end
  unit :gauss        do "1e-4 kg / A s**2"    end
  unit :erg          do "1e-7 kg m**2 / s**2" end

end

