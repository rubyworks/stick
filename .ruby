--- 
name: stick
repositories: 
  public: git://github.com/rubyworks/stick.git
title: Stick
contact: Trans <transfire at gmail.com>
resources: 
  code: http://github.com/rubyworks/stick
  home: http://rubyworks.github.com/stick
pom_verison: 1.0.0
manifest: 
- .ruby/loadpath
- .ruby/name
- .ruby/version
- lib/stick/conversion.rb
- lib/stick/converter.rb
- lib/stick/frame.rb
- lib/stick/measure.rb
- lib/stick/prefix.rb
- lib/stick/system.rb
- lib/stick/type.rb
- lib/stick/unit.rb
- lib/stick/units/au/constants.rb
- lib/stick/units/au/conversions.rb
- lib/stick/units/au/system.rb
- lib/stick/units/au/units.rb
- lib/stick/units/au.rb
- lib/stick/units/si/constants.dat
- lib/stick/units/si/constants.rb
- lib/stick/units/si/conversions.rb
- lib/stick/units/si/prefixes.rb
- lib/stick/units/si/system.rb
- lib/stick/units/si/units.rb
- lib/stick/units/si.rb
- lib/stick/units/uk/foot.rb
- lib/stick/units/uk.rb
- lib/stick/units/us/foot.rb
- lib/stick/units/us.rb
- lib/stick/units.rb
- lib/stick.rb
- lib/stick_legacy/currency.rb
- lib/stick_legacy/units/base.rb
- lib/stick_legacy/units/currency.rb
- lib/stick_legacy/units/data/binary/base.rb
- lib/stick_legacy/units/data/cex.rb
- lib/stick_legacy/units/data/currency/base.rb
- lib/stick_legacy/units/data/currency-default.rb
- lib/stick_legacy/units/data/currency-standard.rb
- lib/stick_legacy/units/data/iec.rb
- lib/stick_legacy/units/data/iec_binary/base.rb
- lib/stick_legacy/units/data/si/base.rb
- lib/stick_legacy/units/data/si/constants.rb
- lib/stick_legacy/units/data/si/derived.rb
- lib/stick_legacy/units/data/si/extra.rb
- lib/stick_legacy/units/data/si/misc.rb
- lib/stick_legacy/units/data/si.rb
- lib/stick_legacy/units/data/uk/base.rb
- lib/stick_legacy/units/data/uk.rb
- lib/stick_legacy/units/data/units-default.rb
- lib/stick_legacy/units/data/units-standard.rb
- lib/stick_legacy/units/data/us/base.rb
- lib/stick_legacy/units/data/us.rb
- lib/stick_legacy/units/data/xmethods/cached.rb
- lib/stick_legacy/units/data/xmethods/mapping.rb
- lib/stick_legacy/units/data/xmethods.rb
- lib/stick_legacy/units/loaders.rb
- lib/stick_legacy/units/units.rb
- lib/stick_legacy/units.rb
- lib/stick_legacy.rb
- test/case/measure/factor.rb
- test/demo/conversion.qed
- test/demo/equality.qed
- test/demo/helper.rb
- test/demo/operations.qed
- test/spec/spec_matrix.rb
- test/unit/test_constants.rb
- test/unit/test_currency.rb
- test/unit/test_infinity.rb
- test/unit/test_interval.rb
- test/unit/test_math.rb
- test/unit/test_matrix.rb
- test/unit/test_units.rb
- RELEASE
- README.rdoc
- HISTORY
- VERSION
- COPYING
version: 1.4.0
copyright: Copyright (c) 2009 Thomas Sawyer
licenses: 
- Apache 2.0
description: Stick is a very elegant and comprehensive units system providing SI units, US English units, UK Imperial Units, and two variations of Plank units, all via a very easy to use method-based interface. It also include a large set of real world contants, provided in "m kg s" and "cm kg s" SI units, and any of the other units of measure.
organization: RubyWorks
summary: Advanced Unit System for Ruby
authors: 
- Thomas Sawyer
created: 2009-11-05
