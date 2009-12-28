module Stick

  # [c, g, h, u, k]
  system :au, [1, 1, 1, 1, 1]

  # B A S E  U N I T S

  au.unit :space,     :S, :space,        :base => true
  au.unit :time,      :T, :time,         :base => true

  au.unit :mass,      :M, :mass,         :base => true  # E = M c2
  au.unit :charge,    :Q, :charge,       :base => true

  au.unit :thermal,   :O, :temperature,  :base => true
  au.unit :energy,    :E, :energy,       :base => true

  au.unit :radian,    :rad,  :angle,     :base => true

  # D E R I V E D  U N I T S

  au.unit :frequency,   :Z, :frequency
  au.unit :force,       :F, :force
  au.unit :pressure,    :P, :pressure
  au.unit :power,       :W, :power

  # D E R I V E D  E L E C T R I C  U N I T S

  au.unit :voltage,     :eV, :electric_voltage
  au.unit :current,     :eI, :electric_current
  au.unit :capacitance, :eC, :electric_capacitance
  au.unit :resistance,  :eR, :electric_resistance
  au.unit :conductance, :eS, :electric_conductance

  au.unit :influx,      :uF, :magnetic_flux
  au.unit :induction,   :uB, :magnetic_induction   # magnetic flux density
  au.unit :inductance,  :uL, :magnetic_inductance

  #
  #au.unit :velocity,    :"S T-1", :velocity

  #au.unit :area,        :A, :area
  #au.unit :volume,      :V, :volume


  # B A S E  C O N V E R S I O N S

  au.Z = 1 / au.T

  au.E = "M S2 / T2"

  au.F = "E / S"          # au.E / au.S
  au.F = "M S / T2"       # au.M * au.S / au.T ** 2

  au.P = "E / S3"         # au.E / au.S ** 3
  au.P = "M / S T2"       # au.M / au.S * au.T ** 2

  au.W = "E / T"
  au.W = "M S2 / T3"

  au.eI = "Q / T"         # au.Q / au.T

  au.eC = "Q2 / E"
  au.eC = "Q2 T2 / M S2"  # au.Q ** 2 * au.T ** 2 / au.M * au.S

  au.eV = "E S / Q"
  au.eV = "M S3 / Q T2"

  au.eR = "E T / Q2"
  au.eR = "M S2 / T Q2"

  au.eS = "Q2 / E"
  au.eS = "T Q2 / M S2"

  au.uF = "E T / Q"
  au.uF = "M S2 / T Q"

  au.uB = "M / Q T"

  au.uL = "E T2 / Q2"
  au.uL = "M S2 / Q2"

end

