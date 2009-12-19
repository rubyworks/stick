module Stick::Units

  s, t, m, q, o = *si.frame

  # A U  C O N V E R S I O N

  si.m  = s * au.S

  si.s  = t * au.T

  si.kg = m * au.M

  si.K  = o * au.O

  si.A  = (t / q) * au.I

  si.g  = m * 0.001 * au.mass

  si.N  = m * s / t * au.force

  si.Pa = (m * s**3 / t) * au.pressure

  # S I  C O N V E R S I O N S

  si.g  = 0.001 * si.kg

  si.km = 1000 * si.m

  si.N  = si.kg * si.m / si.s

  si.Pa = si.kg * si.m**3 / si.s


  # TODO: this should be automatically inferred from si.m = s * au.S

  au.S  = (1 / s) * si.m

end

