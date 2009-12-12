# http://physics.nist.gov/cuu/Units/outside.html

require 'si/derived'

converter "si_extra" do
  unit(:minute, :min){ "60.0 si_base:s" }
  unit(:hour,   :hr ){ "60.0 min" }
  unit(:day,    :d  ){ "24.0 hr" }
  unit(:liter,  :L  ){ "si_base:dm**3" }

  unit(:neper,  :Np ){ "" }
  #unit( :bel, :B { "(1/2) ln 10 Np" }
  #unit( :decibel, :dB ){ "10 B" }

  unit(:are,      :a    ){ "si_base:dam**2" }
  unit(:hectare,  :ha   ){ "si_base:hm**2" }
 #unit(:bar             ){ "100.0 si_derived:kPa" }
  unit(:barn            ){ "100.0 si_base:fm**2" }
  unit(:curie,    :Ci   ){ "3.7e10 si_derived:Bq" }
  unit(:roentgen, :R    ){ "2.58e-4 si_derived:C / si_base:kg" }

  unit(:metric_ton,  :t ){ "1000.0 si_base:kg" }
  unit(:nautical_mile   ){ "1852.0 si_base:m" }
  unit(:knot            ){ "nautical_mile / hr" }

  unit(:rad){ "1e-2 si_derived:Gy" }
  unit(:rem){ "1e-2 si_derived:Sv" }

  unit(:degree){ "0.0174532925199433 si_derived:rad" }
  unit(:angstrom){ "10e-10 m" }
  unit(:electronvolt, :eV){ "1.60218e-19 si_derived:J" }
  unit(:astronomical_unit, :ua){ "1.49598e11 si_base:m" }
  unit(:unified_atomic_mass_unit, :u){ "1.66054e-27 si_base:kg" }
end

