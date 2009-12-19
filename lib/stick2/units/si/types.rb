module Stick::Units

  # SI Metric conversion
  c = 299792458.0     # m / s
  g = 6.67428e-11     # m3 kg-1 s-2
  h = 6.62606896e-34  # m2 kg / s
  u = 1.25663706e-6   # N / A2
  k = 1.3806504e-23   # J / K

  system :si, [c, g, h, u, k]

  # B A S E  U N I T S

  si.type :meter,     :space,       :m,   :base => true
  si.type :second,    :time,        :s,   :base => true
  si.type :kilogram,  :mass,        :kg,  :base => true
  si.type :ampere,    :current,     :A,   :base => true
  si.type :kelvin,    :temperature, :K,   :base => true
  si.type :mole,      :number,      :mol, :base => true

  # D E R I V E D  U N I T S

  si.type :gram,      :mass,        :g
  si.type :newton,    :force,       :N
  si.type :pascal,    :pressure,    :Pa
  si.type :kilometer, :space,       :km

end

