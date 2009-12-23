module Stick::Units

  # B A S E  U N I T S

  si.unit :meter,      :m,    :space,        :base=>true
  si.unit :second,     :s,    :time,         :base=>true
  si.unit :kilogram,   :kg,   :mass,         :base=>true,  :prefix=>false
  si.unit :kelvin,     :K,    :temperature,  :base=>true
  si.unit :ampere,     :A,    :current,      :base=>true

  si.unit :candela,    :cd,   :luminance,    :base => true, :alt=>:luminous_intensity
  si.unit :mole,       :mol,  :number,       :base => true

  # D E R I V E D  U N I T S

  si.unit :gram,       :g,    :mass
  si.unit :kilometer,  :km,   :space,        :prefix=>false

  si.unit :radian,     :rad,  :angle,        :base=>true     # serves as a base unit
  si.unit :steradian,  :sr,   :solid_angle,  :base=>true     # serves as a base unit

  si.unit :hertz,      :Hz,   :frequency
  si.unit :newton,     :N,    :force
  si.unit :pascal,     :Pa,   :pressure
  si.unit :joule,      :J,    :energy
  si.unit :watt,       :W,    :power

  si.unit :coulomb,    :C,    :electric_current
  si.unit :volt,       :V,    :electric_voltage              # :electromotive_force
  si.unit :farad,      :F,    :electric_capacitance
  si.unit :ohm,        :ohm,  :electric_resistance
  si.unit :siemens,    :S,    :electric_conductance

  si.unit :weber,      :Wb,   :magnetic_flux
  si.unit :tesla,      :T,    :magnetic_induction            # :magnetic_flux_density
  si.unit :henry,      :H,    :magnetic_inductance, :plural=>:henries

  si.unit :lumen,      :lm,   :luminosity                    # :luminous_flux
  si.unit :lux,        :lx,   :illuminance, :alias=>:luxen   # :luminous_emittance

  si.unit :gray,       :Gy,   :radiation
  si.unit :sievert,    :Sv,   :radiation
  si.unit :becquerel,  :Bq,   :radionuclide_activity
  si.unit :katal,      :kat,  :catalytic_activity

  si.unit :celsius,    :"C°", :temperature

  # E X T R A  U N I T S

  si.unit :decibel,    :dB,    :ratio, :prefix=>false, :base => true    # serves as a base unit
  si.unit :bel,        :B,     :ratio
  si.unit :neper,      :Np,    :ratio

  si.unit :minute,     :min,   :time
  si.unit :hour,       :hr ,   :time    # technically the symbol is h
  si.unit :day,        :d  ,   :time

  si.unit :arcdegree,  :"°",   :angle,   :prefix=>false
  si.unit :arcmin,     :"'",   :angle,   :prefix=>false
  si.unit :arcsec,     :'"',   :angle,   :prefix=>false

  si.unit :liter,      :L,     :volume
  si.unit :tonne,      :t,     :weight,  :alias=>:metric_ton 

  si.unit :electronvolt,       :eV, :energy
  si.unit :atomic_mass_unit,   :u,  :mass
  si.unit :astronomical_unit,  :ua, :space

  # E X T R A  U N I T S (under further review)

  si.unit :nautical_mile,  :nmi,   :space
  si.unit :knot,           :knot,  :velocity
  si.unit :are,            :a,     :area
  si.unit :hectare,        :ha,    :area
  si.unit :bar,            :bar,   :pressure
  si.unit :angstrom,       :"Å",   :space
  si.unit :barn,           :b,     :area
  si.unit :curie,          :Ci,    :radioactivity

  si.unit :roentgen,       :R,     :electric_radiation

  #si.unit :rad,            :rad,   :radiation
  #si.unit :rem,            :rem,   :radiation

end

