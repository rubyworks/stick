= How Units.rb Works

== Basics

There are two types of units: base units, which are not expressed in
function of other units, and derived units which are expressed as a
function of other units. The base units are represented by the
Stick::Units::BaseUnit class. Derived units are implemented by
Stick::Units::Unit. Derived units are represented as the product of
powers of other units that can  be base units or derived units. These
powers are kept in a Hash. BaseUnit is never exposed to the user; if
you need a base unit, is represented as a Unit that's the product of a
single BaseUnit to the power 1. To be able to work with units, it's
often necessary to normalize them in some way, i.e., express them in
function of base units only. This is done by the Unit#simplify method.
This normalization is not performed automatically; rather we have
chosen to have the user of units.rb initiate any conversion so he or
she can have more control over rounding errors and such. Units can be
multiplied, divided and exponentiated.

Units by itself are not very interesting unless they are combined with
some numeric value. This is what the Stick::Units::Value class does.
It holds a Unit, and a value which can be integers, float,
BigDecimals, complex numbers, etc. Values can be multiplied, divided,
and added and subtracted if the units are compatible. This is checked
by normalizing the units and then transforming the Value with the
larger unit to the smaller unit. For instance, adding inches and feet
will result in inches because an inch is the smaller unit. Value
supports most other numeric operators.

== Converters

units.rb has the notion of converters. This notion has been introduced
because sometimes units have the same name but differ in value
depending on location (e.g., a hundredweight in the UK and the US),
they can have the same symbol though they are different, or in the
case of currency you might want to use different services with
possibly slightly different exchange rates. A unit belongs
unambiguously to a single converter. Units from different converters
can be used together, so it is possible to use US and UK
hundredweights in the same expression. What happens here is that a
unit is not only determined by a name but also by a converter. That's
all there is to it really.

There's always the notion of a current converter. When constructing a
unit, the current converter is used by default unless specified
otherwise. This current converter can be changed with
Stick::Units.with_unit_converter which takes a block. The current
converter is stored in a thread-local variable for the duration of the
block and is taken from there. This gives the user means to specify
what unit systems to use in a more granular way. Converter can include
other converter. This allows a converter to extend another converter
and override some of the names. This is actually what
Stick::Units.with_unit_converter does: internally it creates an
anonymous converter that includes both the previous "current
converter" and the new one which gets stacked on top and thus takes
precedence.

== Syntactic Sugar

Units are specified using symbols like :mile and :in, but units.rb
offers a lot of syntactic sugar to make it easier to use. After
including Stick::Units, you can use mile and in directly, or even do
1.in and 2.miles. This is implemented through method_missing and
const_missing (for units that start with a capital letter).

== Loading Config Files

units.rb uses a DSL to specify converters and units. These DSLs are
conveniently used in the config files to preload a large number of
units.

