module Stick
module Constants

    # = Unit-less constants
    #
    # Stick::Contants::Number::FINE_STRUCTURE  #=> 7.297352533e-3
    #
    module Number
      FINE_STRUCTURE  = 7.297352533e-3 # 1
      AVOGADRO        = 6.02214199e23  # 1
      YOTTA           = 1e24  # 1
      ZETTA           = 1e21  # 1
      EXA             = 1e18  # 1
      PETA            = 1e15  # 1
      TERA            = 1e12  # 1
      GIGA            = 1e9   # 1
      MEGA            = 1e6   # 1
      KILO            = 1e3   # 1
      MILLI           = 1e-3  # 1
      MICRO           = 1e-6  # 1
      NANO            = 1e-9  # 1
      PICO            = 1e-12 # 1
      FEMTO           = 1e-15 # 1
      ATTO            = 1e-18 # 1
      ZEPTO           = 1e-21 # 1
      YOCTO           = 1e-24 # 1
    end

    include Number

end
end

module Math
  include Stick::Constants::Number
end
