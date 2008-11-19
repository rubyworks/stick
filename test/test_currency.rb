$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'stick/currency'

class TestUnitsCurrency < Test::Unit::TestCase

  include Stick::Units

  def test_typerror
    assert_raises(TypeError) do
      assert_equal(1.usd,  1.try.to(:usd))
    end
  end

  def test_cex
    e = 1.twd().unit
    r = 1.usd(:cex).to(twd(:cex))
    assert_equal( e, r.unit )
  end

  def test_usd_to_tws
    assert_equal( 1.tws, 1.usd.to(tws) )
  end

end
