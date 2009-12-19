module Stick::Units

  system :au

  # B A S E  U N I T S

  au.type :space,   :space,       :S,  :base => true
  au.type :time,    :time,        :T,  :base => true
  au.type :mass,    :mass,        :M,  :base => true
  au.type :charge,  :charge,      :Q,  :base => true
  au.type :thermal, :temperature, :O,  :base => true

  # D E R I V E D  U N I T S

  au.type :force,    :force,      :F
  au.type :pressure, :pressure,   :P
  au.type :current,  :current,    :I

end

