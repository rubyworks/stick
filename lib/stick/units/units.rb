require 'stick/units/base'

module Stick
module Units

  class SILoader < Loader

    # The prefixes used for SI units. See also Converter#register_si_unit.
    SI_PREFIXES = {
      'yotta' => {:abbrev => 'Y',  :multiplier => 1e24},
      'zetta' => {:abbrev => 'Z',  :multiplier => 1e21},
      'exa'   => {:abbrev => 'E',  :multiplier => 1e18},
      'peta'  => {:abbrev => 'P',  :multiplier => 1e14},
      'tera'  => {:abbrev => 'T',  :multiplier => 1e12},
      'giga'  => {:abbrev => 'G',  :multiplier => 1e9},
      'mega'  => {:abbrev => 'M',  :multiplier => 1e6},
      'kilo'  => {:abbrev => 'k',  :multiplier => 1e3},
      'hecto' => {:abbrev => 'h',  :multiplier => 1e2},
      'deca'  => {:abbrev => 'da', :multiplier => 1e1},
      'deci'  => {:abbrev => 'd',  :multiplier => 1e-1},
      'centi' => {:abbrev => 'c',  :multiplier => 1e-2},
      'milli' => {:abbrev => 'm',  :multiplier => 1e-3},
      'micro' => {:abbrev => 'u',  :multiplier => 1e-6},
      'nano'  => {:abbrev => 'n',  :multiplier => 1e-9},
      'pico'  => {:abbrev => 'p',  :multiplier => 1e-12},
      'femto' => {:abbrev => 'f',  :multiplier => 1e-15},
      'atto'  => {:abbrev => 'a',  :multiplier => 1e-18},
      'zepto' => {:abbrev => 'z',  :multiplier => 1e-21},
      'yocto' => {:abbrev => 'y',  :multiplier => 1e-24}
    }

    handles 'si_unit'

    def si_unit(converter, name, args)
      converter.send(:register_prefixed_unit, name, SI_PREFIXES, args)
    end

  end

  class LengthLoader < Loader

    # The prefixes used for length units. See also Converter#register_length_unit.
    LENGTH_PREFIXES = {
      'square_' => {:abbrev => 'sq_', :power => 2},
      'cubic_' => {:abbrev => 'cu_', :power => 3}
    }

    handles 'length_unit'

    def length_unit(converter, name, args)
      converter.send(:register_prefixed_unit, name, LENGTH_PREFIXES, args)
    end

  end

  class BinaryLoader < Loader

    # The prefixes used for binary units. See also Converter#register_binary_unit.
    BINARY_PREFIXES = {
      'yotta' => {:abbrev => 'Y', :multiplier => 1024.0 ** 8},
      'zetta' => {:abbrev => 'Z', :multiplier => 1024.0 ** 7},
      'exa'   => {:abbrev => 'E', :multiplier => 1024.0 ** 6},
      'peta'  => {:abbrev => 'P', :multiplier => 1024.0 ** 5},
      'tera'  => {:abbrev => 'T', :multiplier => 1024.0 ** 4},
      'giga'  => {:abbrev => 'G', :multiplier => 1024.0 ** 3},
      'mega'  => {:abbrev => 'M', :multiplier => 1024.0 ** 2},
      'kilo'  => {:abbrev => 'k', :multiplier => 1024.0},
    }

    handles 'binary_unit'

    def binary_unit(converter, name, args)
      converter.send(:register_prefixed_unit, name, BINARY_PREFIXES, args)
    end

  end

  class IECBinaryLoader < Loader

    # The prefixes used for binary units in the IEC system.
    # See also Converter#register_binary_iec_unit.
    BINARY_IEC_PREFIXES = {
      'yobi'  => {:abbrev => 'Yi', :multiplier => 1024.0 ** 8},
      'zebi'  => {:abbrev => 'Zi', :multiplier => 1024.0 ** 7},
      'exbi'  => {:abbrev => 'Ei', :multiplier => 1024.0 ** 6},
      'pebi'  => {:abbrev => 'Pi', :multiplier => 1024.0 ** 5},
      'tebi'  => {:abbrev => 'Ti', :multiplier => 1024.0 ** 4},
      'gibi'  => {:abbrev => 'Gi', :multiplier => 1024.0 ** 3},
      'mebi'  => {:abbrev => 'Mi', :multiplier => 1024.0 ** 2},
      'kibi'  => {:abbrev => 'ki', :multiplier => 1024.0},

      'yotta' => {:abbrev => 'Y',  :multiplier => 1e24},
      'zetta' => {:abbrev => 'Z',  :multiplier => 1e21},
      'exa'   => {:abbrev => 'E',  :multiplier => 1e18},
      'peta'  => {:abbrev => 'P',  :multiplier => 1e14},
      'tera'  => {:abbrev => 'T',  :multiplier => 1e12},
      'giga'  => {:abbrev => 'G',  :multiplier => 1e9},
      'mega'  => {:abbrev => 'M',  :multiplier => 1e6},
      'kilo'  => {:abbrev => 'k',  :multiplier => 1e3},
    }

    handles 'binary_iec_unit'

    def binary_iec_unit(converter, name, args)
      converter.send(:register_prefixed_unit, name, BINARY_IEC_PREFIXES, args)
    end

  end

end
end
