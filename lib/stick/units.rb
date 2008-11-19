require 'stick/units/units'

module Stick
module Units

  # Load conversion units.
  class Converter
    require("units-standard")
  end

end
end


# Checkrun

=begin check

  class A

    include Stick::Units

    def test
      puts 1.bit/s + 8.bytes/s

      puts((1.bit/s).to(byte/s))

      puts 1.mile.to(feet)

      puts 1.acre.to(yd**2)

      puts 1.acre.to(sq_yd)

      puts 1.gallon.to(L)

      puts 1.lb.to(kg)

      puts 1.m.s.to(m.s)

      puts 1.sq_mi.to(km**2)

      puts 1.mile.to(km)

      #puts 1.usd.to(twd)

      with_unit_converter(:uk) {
        puts 1.cwt.to(lb)
      }

      with_unit_converter(:us) {
        puts 1.cwt.to(lb)
      }

      puts 1.cwt(:uk).to(lb(:uk))
      puts 1.cwt(:us).to(lb(:us))

      puts Converter.current.lb

      p Converter.registered_converters

      #begin
      #  puts 1.try.to(usd)
      #rescue TypeError
      #  p $!
      #end

      #puts 1.usd(:cex).to(twd(:cex))

      puts 1.cwt(:uk).to(cwt(:us))
      puts 1.cwt(:us).to(cwt(:uk))

      with_unit_converter(:uk) {
        puts 1.cwt(:uk).to(cwt(:us))
        puts 1.cwt(:us).to(cwt(:uk))
      }

      p (1.m <=> 1.L)
      p (1.m <=> 1.cm)

      p((1.MB / s).to(kB / s))

      with_unit_converter(:binary_iec_base) {
        p((1.MB / s).to(kB / s))
      }

      p "m / s".to_unit
      p "1 m / s".to_value

      p "1 m / cm L".to_value.simplify

      p "1 m / cm".to_value.to_f

      p 1.m.to("cm")

      p 1.m + "5cm"

      p 1.m + 5.cm

      p 5.cm + 1.m

      p cm * m

      p cm * "m"

      p "-5mm".to_value

      p "-5mm".to_value.abs

      p ("5.0mm".to_value / 1).infinite?
    end
  end

  A.new.test

=end

