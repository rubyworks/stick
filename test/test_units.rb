$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'stick/units'

class TestUnits < Test::Unit::TestCase

  include Stick::Units

  def assert_in_unit_delta(v1, v2, d)
    assert( v2 * (1 - d) <= v1 && v1 <= v2 * (1 + d), "<#{v1}> expected but was\n<#{v2}>" )
  end

  def test_bit_and_bytes
    assert_equal( 65.bit/s,  1.bit/s + 8.bytes/s )
    assert_equal( 0.125.byte/s, ((1.bit/s).to(byte/s)) )
    # PETER : Why 0?
    # assert_equal( 0, ((1.bit/s).to(byte/s)) )
  end

  def miles_to_feet
    assert_equal( 5000.feet,  1.mile.to(feet) )
  end

  def test_acre_to_yards_squared
    assert_equal( 4840.sq_yd,  1.acre.to(yd**2) )
    # PETER : This obviously fails because yards and square yards are not the same.
    # assert_equal( 4840.yd,  1.acre.to(yd**2) )
  end

  def test_acre_to_sq_yd
    assert_equal( 4840.sq_yd,  1.acre.to(sq_yd) )
  end

  def test_gallon_to_liter
    assert_in_unit_delta( 3.785411784.L, 1.gallon.to(L), 1e-15 )
    # PETER : A gallon expressed in liters is not a liter.
    # assert_equal( 1.L, 1.gallon.to(L) )
  end

  def test_lb_to_kg
    assert_equal( 0.45359237.kg, 1.lb.to(kg) )
  end

  def test_m_s_to_m_s
    assert_equal( 1.m.s, 1.m.s.to(m.s) )
  end

  def test_sq_mi_to_km_squared
    assert_in_unit_delta( 2.589988110336.to_value(km**2), 1.sq_mi.to(km**2), 1e-15 )
    # PETER : See comment in #test_bandwidth.
    # assert_equal( 1.to(km**2), 1.sq_mi.to(km**2) )
  end

  def test_mile_to_km
    assert_in_unit_delta( 1.609344.km, 1.mile.to(km), 1e-15 )
    # PETER : These are floats, they don't compare.
    # assert_equal( 1.609344.km, 1.mile.to(km) )
  end

  def test_with_unit_convertor_uk
    with_unit_converter(:uk) {
      assert_equal( 112.lb,  1.cwt.to(lb) )
    }
    assert_equal( 112.lb(:uk), 1.cwt(:uk).to(lb(:uk)) )
    # PETER : That would be a very small hundredweight
    # assert_equal( 1.lb(:uk), 1.cwt(:uk).to(lb(:uk)) )
  end

  def test_with_unit_convertor_us
    with_unit_converter(:us) {
      assert_equal( 100.lb,  1.cwt.to(lb) )
    }
    assert_equal( 100.lb(:us), 1.cwt(:us).to(lb(:us)) )
    # PETER : That would be a very small hundredweight
    # assert_equal( 1.lb(:us), 1.cwt(:us).to(lb(:us)) )
  end

  def test_current_lb
    assert_equal( lb, Converter.current.lb )
    # PETER : compares values and units again.
    # assert_equal( 1.lb, Converter.current.lb )
  end

  def test_cwt
    assert_equal( 1.12.cwt(:us), 1.cwt(:uk).to(cwt(:us)) )
    assert_equal( 1.cwt(:uk), 1.12.cwt(:us).to(cwt(:uk)) )
  end

  def test_unit_convertor_cwt
    with_unit_converter(:uk) {
      assert_equal( 1.cwt, 1.cwt.to(cwt(:us)) )
      assert_equal( 1.cwt(:us), 1.cwt(:us).to(cwt) )
      # PETER : This is not correct. The conversion does
      #   not change the magnitude of the thing, i.e.,
      #   something that weighs a hundredweight UK style does
      #   not weigh a hundredweight US style even when its
      #   weight us expressed in US style hundredweights
      #   (if that makes sense.)
      #   Also, this converter has no effect because the
      #   converter is specified everywhere. So it is really
      #   the same as the above.
      # assert_equal( 1.cwt(:us), 1.cwt(:uk).to(cwt(:us)) )
      # assert_equal( 1.cwt(:uk), 1.cwt(:us).to(cwt(:uk)) )
    }
  end

  #def test_registered_convertors
  #  assert_equal( [:cex, :default, :uk, :us], Converter.registered_converters.sort )
  #end

  def test_spaceship
    assert_nil( 1.m <=> 1.L )
    # PETER : meter and liter are like apples and oranges.
    #   returns nil instead.
    # assert_equal( 0, (1.m <=> 1.L) )
    assert_equal( 1, (1.m <=> 1.cm) )
  end

  def test_bandwidth
    assert_equal( 1024.to_value(kB / s), ((1.MB / s).to(kB / s)) )
    with_unit_converter(:binary_iec_base) {
      assert_equal( 1000.to_value(kB / s), ((1.MB / s).to(kB / s)) )
    }
    # PETER : The #to method does conversion from one unit
    #   to another compatible unit. Although it could make
    #   sense to convert a unitless number to a unit
    #   that is essentially unitless too (like kB/MB), there
    #   are better ways to do the same, and the below still
    #   wouldn't work because 1 is unitless and 1.kB/s is not.
    #   I've added a to_value method for this.
    # assert_equal( 1.to(kB / s), ((1.MB / s).to(kB / s)) )
    # with_unit_converter(:binary_iec_base) {
    #   assert_equal( 1.to(kB / s), ((1.MB / s).to(kB / s)) )
    # }
  end

  def test_to_unit
    assert_equal( m / s, "m / s".to_unit )
    # PETER : m/s and 1 m/s are not the same thing.
    # assert_equal( 1.to(m / s), "m / s".to_unit )
  end

  def test_to_value
    assert_equal( 1.m / s, "1 m / s".to_value )
    # PETER : See remark in #test_bandwidth.
    # assert_equal( 1.to(m / s), "1 m / s".to_value )
  end

  def test_simplify
    # PETER : Don't see how this could be zero. Don't know
    #   exactly what you want to test though...
    # assert_equal( 0, "1 m / cm L".to_value.simplify )
  end

  def test_float
    assert_equal( 100.0, "1 m / cm".to_value.to_f )
  end

  def test_m_to_str_cm
    assert_equal( 100.cm, 1.m.to("cm") )
  end

  def test_m_plus_str_cm
    assert_equal( 105.cm, 1.m + "5cm" )
  end

  def test_plus
    assert_equal( 1.05.m, 1.m + 5.cm )
  end

  def test
    assert_equal( 105.m, 5.cm + 1.m )
  end

  # PETER : This compares a value (quantity + unit) to a unit. This could
  #   be allowed by saying that the unit of meter and 1 meter is the
  #   same, but personally I'd like to keep the distinction.
  # def test_
  #   assert_equal( 101.cm, cm * m )
  # end

  # def test_
  #   assert_equal( 101.cm, cm * "m" )
  # end

  def test_value
    assert_equal(-5.mm, "-5mm".to_value )
    # PETER : -5mm is not the same as -5
    # assert_equal(-5, "-5mm".to_value )
  end

  def test_value_abs
    assert_equal(5.mm, "-5mm".to_value.abs )
    # PETER : 5mm is not the same as 5
    # assert_equal(5, "-5mm".to_value.abs )
  end

  def test_infinite?
    # PETER : I'm not sure what the point of this is, but in
    #   any case, a Value does not have an infinite? method
    # assert_equal( false, ("5.0mm".to_value / 1).infinite? )
  end

end
