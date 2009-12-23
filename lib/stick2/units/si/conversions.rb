module Stick::Units

  # S I  B A S E  C O N V E R S I O N S

  si.g   = 0.001 * si.kg
  si.km  = 1000  * si.m

  si.Hz  = "s-1"
  si.N   = "kg m / s"        # (si.kg * si.m) / si.s
  si.Pa  = "kg m3 / s"       # (si.kg * si.m ** 3) / si.s
  si.J   = "kg m2 / s2"
  si.W   = "kg m2 / s3"      # (si.kg * si.m ** 2) / si.s ** 3

  si.C   = "A s"             # si.A * si.s
  si.V   = "kg m3 / A s3"    # (si.kg * si.m ** 3) / (si.A * si.s ** 3)
  si.F   = "m-2 kg-1 s4 A2"  # (si.s ** 4 * si.A ** 2) / (si.kg * si.m ** 2)
  si.ohm = "kg m2 / s3 A2"   # (si.kg * si.m ** 2) / (si.s ** 3 * si.A ** 2)
  si.S   = "s3 A2 / kg m2"   # (si.s**3 * si.A**2) / (si.kg * si.m**2)

  si.Wb  = "kg m2 / s2 A"    # (si.kg * si.m ** 2) / (si.s ** 2 * si.A)
  si.T   = "kg / A s2"       # (si.kg) / (si.A * si.s ** 2)
  si.H   = "m2 kg / A2 s2"   # (si.m ** 2 * si.kg) / (si.A ** 2 * si.s ** 2)

  si.lm  = "cd sr"
  si.lx  = "cd sr m-2"
  si.lx  = "lm m-2"

  si.Gy  = "m2 / s2"
  si.Sv  = "m2 / s2"

  si.Bq  = "s-1"
  si.kat = "mol / s"

  #si.celsius = si.K - 273.15      # can't use symbol

  # E X T R A  U N I T S (not offical SI but acceptable by NIST)

  si.min = 60 * si.s
  si.hr  = 60 * 60 * si.s
  si.day = 60 * 60 * 24 * si.s

  si.arcdegree = (Math::PI / 180) * si.rad
  si.arcmin    = (Math::PI / 60 * 180) * si.rad
  si.arcsec    = (Math::PI / 60 * 60 * 180) * si.rad

  si.L = "m3"
  si.t = 1000 * si.kg

  si.eV = 1.60217646e-19 * si["kg m2 / s2"]
  si.eV = 1.60217646e-19 * si.J

  si.Np = 8.685889638 * si.dB
  si.B  = 10 * si.dB

  si.u  = 1.660538782e-27 * si.kg
  si.ua = 149598000000 * si.m

  # E X T R A  U N I T S (not offical SI but under further review by NIST)

  si.nmi  = 1852 * si.m
  si.knot = 1852 * si.m / 3600 * si.s

  si.a  = 100 * si.m ** 2
  si.ha = 10000 * si.m ** 2

  si.bar = 100000 * si["kg m3 / s"]  # Pa
  si.bar = 100000 * si.Pa

  si.angstrom = 1e-10 * si.m

  si.b = 10e-28 * si.m ** 2

  si.Ci = 3.7e10 / si.s

  si.R  = 2.58e-4 * si.A * si.s / si.kg
  si.R  = 2.58e-4 * si.C / si.kg

  si.mol = 6.0221415e23



=begin
  s, t, m, q, o = *si.frame

  # A U  B A S E  C O N V E R S I O N S

  si.m  = s * au.S
  si.s  = t * au.T
  si.kg = m * au.M
  si.K  = o * au.O
  si.A  = (t / q) * au.eI

  #si.cd =
  #si.mol =

  # TODO: it would be cool if these could be automatically inferred from the above
  au.S  = (1 / s) * si.m


  # A U  D E R I V E D  C O N V E R S I O N S

  si.g  = 0.001 * m * au.M
  si.km = 1000 * s * au.S

  #si.rad = :angle
  #si.sr  = :solid_angle

  si.Hz = (1 / s)           * au.frequency
  si.N  = (m * s / t)       * au.force
  si.Pa = (m * s**3 / t)    * au.pressure
  si.J  = (t**3 / s**3)     * au.energy
  si.W  = (m * s**2 / t**3) * au.power

  si.C   = q                       * au.charge
  si.V   = (m * s**2 / q)          * au.voltage
  si.ohm = (m * s**2 / t * q ** 2) * au.resistance
  si.S   = (t * q**2 / m * s ** 2) * au.conductance
  si.F   = (t**2 * q**2 / m * s)   * au.capacitance

  si.Wb  = (m * s**2 / t * q)      * au.uF
  si.T   = (m / q * t)             * au.uB
  si.H   = (m * s**2 / q**2)       * au.uL

  #si.unit :lumen,      :lm,   :luminosity                    # :luminous_flux
  #si.unit :lux,        :lx,   :illuminance, :alias=>:luxen   # :luminous_emittance

  #si.unit :gray,       :Gy,   :radiation
  #si.unit :sievert,    :Sv,   :radiation
  #si.unit :becquerel,  :Bq,   :radionuclide_activity
  #si.unit :katal,      :kat,  :catalytic_activity

  #si.unit :celsius,    :"C°", :temperature

  # A U  E X T R A  C O N V E R S I O N S

  si.min = t * 60 * au.T
  si.hr  = t * 60 * 60 * au.T
  si.day = t * 60 * 60 * 24 * au.T

  #si.unit :degree_angle,   :"°",   :angle,   :prefix=>false
  #si.unit :minute_angle, 	 :"'",   :angle,   :prefix=>false
  #si.unit :second_angle, 	 :'"',   :angle,   :prefix=>false

  si.L = (s ** 3) * 0.001 * au.S ** 3

  #si.unit :tonne,          :t,     :weight,  :alias=>:metric_ton 
  #si.unit :neper,          :Np,    :number
  #si.unit :decibel,        :dB,    :number,  :prefix=>false
  #si.unit :bel,            :B,     :number
  #si.unit :electronvolt,   :eV,    :energy

  #si.unit :unified_atomic_mass_unit, :u,  :mass
  #si.unit :astronomical_unit,        :ua, :space

  # E X T R A  U N I T S (under further review)

  #si.unit :nautical_mile,  :mi,    :space
  #si.unit :knot,           :knot,  :velocity
  #si.unit :are,            :a,     :area
  #si.unit :hectare,        :ha,    :area
  #si.unit :bar,            :bar,   :pressure
  #si.unit :angstrom,       :"Å",   :space
  #si.unit :barn,           :b,     :area
  #si.unit :curie,          :Ci,    :radioactivity
  #si.unit :roentgen,       :R,     :electric_radiation

  #si.unit :rad,            :rad,   :radiation
  #si.unit :rem,            :rem,   :radiation
=end

end

