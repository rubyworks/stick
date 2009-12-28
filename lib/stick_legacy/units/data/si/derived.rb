# http://physics.nist.gov/cuu/Units/units.html

require 'si/base'

converter 'si_derived' do
  si_unit( :radian,     :rad ){ "" }
  si_unit( :steradian,  :sr  ){ "" }

  si_unit( :hertz,      :Hz  ){ "1 / si_base:s"           }
  si_unit( :newton,     :N   ){ "si_base:kg si_base:m / si_base:s**2" }
  si_unit( :pascal,     :Pa  ){ "N / si_base:m**2"        }
  si_unit( :joule,      :J   ){ "N * si_base:m"           }
  si_unit( :watt,       :W   ){ "J / si_base:s"           }
  si_unit( :coulomb,    :C   ){ "si_base:A * si_base:s"   }
  si_unit( :volt,       :V   ){ "W / si_base:A"           }
  si_unit( :farad,      :F   ){ "C / V"                   }
  si_unit( :ohm              ){ "V / si_base:A"           }
  si_unit( :siemens,    :S   ){ "si_base:A / V"           }
  si_unit( :weber,      :Wb  ){ "V * si_base:s"           }
  si_unit( :tesla,      :T   ){ "Wb / si_base:m**2"       }

  si_unit( :henry,      :H  , :henries  ){ "Wb / si_base:A"    }
  si_unit( :lumen,      :lm             ){ "si_base:cd sr"     }
  si_unit( :lux,        :lx , :luxen    ){ "lm / si_base:m**2" }

  si_unit( :becquerel,  :Bq  ){ "1 / si_base:s"           }
  si_unit( :gray,       :Gy  ){ "J / si_base:kg"          }
  si_unit( :sievert,    :Sv  ){ "J / si_base:kg"          }
  si_unit( :katal,      :kat ){ "si_base:mol / si_base:s" }

  si_unit( :bar              ){ "100.0 kPa" }  # TODO: should this be in si_extra ?
end

