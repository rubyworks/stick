require 'stick/units/si'

TestCase Stick::Measure do

  #include Stick::Units  #TODO: not working, why?

  Unit :factor? => "decerns factors of equal powers" do
    n1 = Stick::Measure.new(1, Stick::Unit.new(Stick.systems[:si].types[:kg], 1))
    n2 = Stick::Measure.new(1, Stick::Unit.new(Stick.systems[:si].types[:kg], 1))
    n2.assert.factor?(n1)
    n1 = Stick::Measure.new(1, Stick::Unit.new(Stick.systems[:si].types[:kg], 2)), Stick::Units::SI::Meter.new, Stick::Units::SI::Second.new(-1))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Newton.new)
    n2.assert.factor?(n1)
  end

  Unit :factor? => "decerns factors of greater positive powers" do
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(2))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(1))
    n2.assert.factor?(n1)
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new, Stick::Units::SI::Meter.new(2), Stick::Units::SI::Second.new(-1))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Newton.new)
    n2.assert.factor?(n1)
  end

  Unit :factor? => "decerns factors of lesser negative powers" do
    n1 = Stick::Measure.new(1, Stick::Unit.new(Stick.systems[:si].types[:kg], 2))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(-1))
    n2.assert.factor?(n1)
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new, Stick::Units::SI::Meter.new, Stick::Units::SI::Second.new(-2))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Newton.new)
    n2.assert.factor?(n1)
  end

  Unit :factor? => "decerns non-factors" do
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new)
    n2 = Stick::Measure.new(1, Stick::Units::SI::Newton.new)
    n2.refute.factor?(n1)
  end

  Unit :factor? => "decerns non-factors of lesser positive powers" do
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(1))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(2))
    n2.refute.factor?(n1)
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new, Stick::Units::SI::Meter.new(-1), Stick::Units::SI::Second.new(-1))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Newton.new)
    n2.refute.factor?(n1)
  end

  Unit :factor? => "decerns non-factors of greater negative powers" do
    n1 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(-1))
    n2 = Stick::Measure.new(1, Stick::Units::SI::Kilogram.new(-2))
    n2.refute.factor?(n1)
  end

end
