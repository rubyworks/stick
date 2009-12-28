require 'si/base'

converter 'uk_base' do
  length_unit(:inch, :in){ "2.54 si_base:cm" }
  length_unit(:foot, :ft){ "12.0 in" }
  length_unit(:yard, :yd){ "3.0 ft" }
  length_unit(:chain    ){ "22.0 yd" }
  length_unit(:furlong  ){ "10.0 chains" }
  length_unit(:mile, :mi){ "8.0 furlongs" }

  unit("acre"                  ){ "10 square_chain" }
  unit("fluid_ounce"  , :fl_oz ){ "2.8413062e-2 si_base:dm**3" }
  unit("gill"                  ){ "5.0 fl_oz" }
  unit("pint"         , :pt    ){ "4.0 gills" }
  unit("quart"        , :qt    ){ "2.0 pt" }
  unit("gallon"       , :gal   ){ "4.0 qt" }
  unit("grain"        , :gr    ){ "6.479891e-5 si_base:kg" }
  unit("ounce"        , :oz    ){ "437.5 gr" }
  unit("pound"        , :lb    ){ "16.0 oz" }
  unit("stone"                 ){ "14.0 lb" }
  unit("hundredweight", :cwt   ){ "8.0 stone" }
  unit("long_ton"     , :lt    ){ "20.0 cwt" }
end

# UK_TON                   = 1.0160469088e3.kg                      # kg
