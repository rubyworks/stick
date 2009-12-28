module Stick

  # B A S E  U N I T S

  au.unit :space,    :S, :space,        :base => true
  au.unit :time,     :T, :time,         :base => true
  au.unit :mass,     :M, :mass,         :base => true
  au.unit :charge,   :Q, :charge,       :base => true
  au.unit :thermal,  :O, :temperature,  :base => true

  # D E R I V E D  U N I T S

  au.unit :force,    :F, :force
  au.unit :pressure, :P, :pressure
  au.unit :current,  :I, :current

  # C O N V E R S I O N S

  au.I = au.Q / au.T
  au.F = au.M * au.S / au.T ** 2
  au.P = au.M / au.S * au.T ** 2

  # C O N S T A N T S
# TODO:
#  au.constant :speed_of_light, :lightspeed, :symbol => :c
#  au.constant :plancks_constant,            :symbol => :h
#  au.constant :gravitational_constant,      :symbol => :G

#  au.speed_of_light = au.S / au.T

end

