require 'si/base'

converter 'us_base' do
  length_unit( :inch, :in        ){ "2.54 si_base:cm" }
  length_unit( :foot, :ft, :feet ){ "12.0 in" }
  length_unit( :yard, :yd        ){ "3.0 ft"  }
  length_unit( :furlong          ){ "220.0 yd" }
  length_unit( :mile, :mi        ){ "8.0 furlongs" }
  length_unit( :acre             ){ "4840.0 sq_yd" }

  unit( :section  ){ "1.0 sq_mi" }
  unit( :township ){ "36.0 sections" }

  unit( :fluid_ounce, :fl_oz ){ "2.95735295625e-2 si_base:dm**3" }
  unit( :gill                ){ "4.0 fl_oz" }
  unit( :cup                 ){ "8.0 fl_oz" }
  unit( :pint, :pt           ){ "4.0 gills" }
  unit( :quart, :qt          ){ "2.0 pt"    }
  unit( :gallon, :gal        ){ "4.0 qt"    }
  unit( :grain, :gr          ){ "6.479891e-5 si_base:kg" }
  unit( :ounce, :oz          ){ "437.5 gr" }
  unit( :pound, :lb          ){ "16.0 oz" }
  unit( :stone               ){ "14.0 lb" }
  unit( :hundredweight, :cwt ){ "100.0 lb" }
  unit( :short_ton, :st      ){ "20.0 cwt" }

  unit( :tablespoon, :Tbsp   ){ "1.47867647813e-5 si_base:m**3" } # FIXME
  unit( :teaspoon, :tsp      ){ "4.92892159375e-6 si_base:m**3" } # FIXME

  unit( :psi                 ){ "6.89475729317e3 kg / m s**2"  }  # FIXME: make per sqr inch

  unit :footcandle   do "1.076e1 cd * sr / m**2"    end                # cd sr / m^2
  unit :lambert      do "1e4.cd sr / m**2"          end                # cd sr / m^2
  unit :footlambert  do "1.07639104e1 cd sr / m**2" end                # cd sr / m^2

  #unit( :miles_per_hour, :mph){ "m / si_extra:hr" }
end


#      POUND_MASS               = 4.5359237e-1.kg                        # kg
#      OUNCE_MASS               = 2.8349523125e-2.kg                     # kg

#      POUND_FORCE              = 4.44822161526e0.kg*m/s**2              # kg m / s^2
#      KILOPOUND_FORCE          = 4.44822161526e3.kg*m/s**2              # kg m / s^2



