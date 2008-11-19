require 'soap/wsdlDriver'
require 'yaml'

SI_BASE = [
  {'type' => 'si', 'name' => 'meter',   'alias' => 'meters',   'abbrev' => 'm'},
  {'type' => 'si', 'name' => 'gram',    'alias' => 'grams',    'abbrev' => 'g'},
  {'type' => 'si', 'name' => 'second',  'alias' => 'seconds',  'abbrev' => 's'},
  {'type' => 'si', 'name' => 'ampere',  'alias' => 'amperes',  'abbrev' => 'A'},
  {'type' => 'si', 'name' => 'kelvin',  'alias' => 'kelvins',  'abbrev' => 'K'},
  {'type' => 'si', 'name' => 'mole',    'alias' => 'moles',    'abbrev' => 'mol'},
  {'type' => 'si', 'name' => 'candela', 'alias' => 'candelas', 'abbrev' => 'cd'},
]

SI_DERIVED = [
  {'type' => 'import', 'file' => 'si/base'},
  {'type' => 'si', 'name' => 'radian',    'alias' => 'radians',    "abbrev" => 'rad', 'equals' => ''},
  {'type' => 'si', 'name' => 'steradian', 'alias' => 'steradians', "abbrev" => 'sr',  'equals' => ''},
  {'type' => 'si', 'name' => 'hertz',                             "abbrev" => 'Hz',  'equals' => '1/s'},
  {'type' => 'si', 'name' => 'newton',    'alias' => 'newtons',    "abbrev" => 'N',   'equals' => 'kg*m/s**2'},
  {'type' => 'si', 'name' => 'pascal',    'alias' => 'pascals',    "abbrev" => 'Pa',  'equals' => 'N/m**2'},
  {'type' => 'si', 'name' => 'joule',     'alias' => 'joules',     "abbrev" => 'J',   'equals' => 'N*m'},
  {'type' => 'si', 'name' => 'watt',      'alias' => 'watts',      "abbrev" => 'W',   'equals' => 'J/s'},
  {'type' => 'si', 'name' => 'coulomb',   'alias' => 'coulombs',   "abbrev" => 'C',   'equals' => 'A*s'},
  {'type' => 'si', 'name' => 'volt',      'alias' => 'volts',      "abbrev" => 'V',   'equals' => 'W/A'},
  {'type' => 'si', 'name' => 'farad',     'alias' => 'farads',     "abbrev" => 'F',   'equals' => 'C/V'},
  {'type' => 'si', 'name' => 'ohm',       'alias' => 'ohms',                         'equals' => 'V/A'},
  {'type' => 'si', 'name' => 'siemens',                            "abbrev" => 'S',   'equals' => 'A/V'},
  {'type' => 'si', 'name' => 'weber',     'alias' => 'webers',     "abbrev" => 'Wb',  'equals' => 'V*s'},
  {'type' => 'si', 'name' => 'tesla',     'alias' => 'teslas',     "abbrev" => 'T',   'equals' => 'Wb/m**2'},
  {'type' => 'si', 'name' => 'henry',     'alias' => 'henries',    "abbrev" => 'H',   'equals' => 'Wb/A'},
  {'type' => 'si', 'name' => 'lumen',     'alias' => 'lumens',     "abbrev" => 'lm',  'equals' => 'cd*sr'},
  {'type' => 'si', 'name' => 'lux',       'alias' => 'luxen',      "abbrev" => 'lx',  'equals' => 'lm/m**2'},
  {'type' => 'si', 'name' => 'becquerel', 'alias' => 'becquerels', "abbrev" => 'Bq',  'equals' => '1/s'},
  {'type' => 'si', 'name' => 'gray',      'alias' => 'grays',      "abbrev" => 'Gy',  'equals' => 'J/kg'},
  {'type' => 'si', 'name' => 'sievert',   'alias' => 'sieverts',   "abbrev" => 'Sv',  'equals' => 'J/kg'},
  {'type' => 'si', 'name' => 'katal',     'alias' => 'katals',     "abbrev" => 'kat', 'equals' => 'mol/s'},
  {'type' => 'si', 'name' => 'bar',       'alias' => 'bars',       "abbrev" => 'bar', 'equals' => '100.0 kPa'}
]

SI_EXTRA = [
  {'type' => 'import', 'file' => 'si/derived'},
  {'type' => 'unit', 'name' => 'minute',        'alias' => 'minutes',        "abbrev" => 'min', 'equals' => '60.0 s'}, 
  {'type' => 'unit', 'name' => 'hour',          'alias' => 'hours',          "abbrev" => 'h',   'equals' => '60.0 min'},
  {'type' => 'unit', 'name' => 'day',           'alias' => 'days',           "abbrev" => 'd',   'equals' => '24.0 h'},
  {'type' => 'unit', 'name' => 'liter',         'alias' => 'liters',         "abbrev" => 'L',   'equals' => 'dm**3'},
  {'type' => 'unit', 'name' => 'neper',         'alias' => 'nepers',         "abbrev" => 'Np',  'equals' => ''},
  {'type' => 'unit', 'name' => 'electronvolt',  'alias' => 'electronvolts',  "abbrev" => 'eV',  'equals' => '1.60218e-19 J'},
  {'type' => 'unit', 'name' => 'are',           'alias' => 'ares',           "abbrev" => 'a',   'equals' => 'dam**2'},
  {'type' => 'unit', 'name' => 'hectare',       'alias' => 'hectares',       "abbrev" => 'ha',  'equals' => 'hm**2'},
  {'type' => 'unit', 'name' => 'barn',          'alias' => 'barns',                            'equals' => '100.0 fm**2'},
  {'type' => 'unit', 'name' => 'curie',         'alias' => 'curies',         "abbrev" => 'Ci',  'equals' => '3.7e10 Bq'},
  {'type' => 'unit', 'name' => 'roentgen',      'alias' => 'roentgens',      "abbrev" => 'R',   'equals' => '2.58e-4 kg'},
  {'type' => 'unit', 'name' => 'metric_ton',    'alias' => 'metric_tons',    "abbrev" => 't',   'equals' => '1000.0 kg'},
  {'type' => 'unit', 'name' => 'degree',        'alias' => 'degrees',        'equals' => "#{Math::PI / 180} rad"},
  {'type' => 'unit', 'name' => 'nautical_mile', 'alias' => 'nautical_miles', 'equals' => '1852.0 m'},
  {'type' => 'unit', 'name' => 'knot',          'alias' => 'knots',          'equals' => 'nautical_mile/h'},
  {'type' => 'unit', 'name' => 'angstrom',      'alias' => 'angstroms',      'equals' => '100.0 kPa'},
  {'type' => 'unit', 'name' => 'unified_atomic_mass_unit', 'alias' => 'unified_atomic_mass_units', "abbrev" => 'u',  'equals' => '1.66054e-27 kg'},
  {'type' => 'unit', 'name' => 'astronomical_unit',        'alias' => 'astronomical_units',        "abbrev" => 'ua', 'equals' => '1.49598e11 m'}
]

IMPERIAL_BASE = [
  {'type' => 'import', 'file' => 'si/base'},
  {'type' => 'length', 'name' => 'inch',          'alias' => 'inches',         "abbrev" => 'in',    'equals' => '2.54 cm'},
  {'type' => 'length', 'name' => 'foot',          'alias' => 'feet',           "abbrev" => 'ft',    'equals' => '12.0 in'},
  {'type' => 'length', 'name' => 'yard',          'alias' => 'yards',          "abbrev" => 'yd',    'equals' => '3.0 ft'},
  {'type' => 'length', 'name' => 'chain',         'alias' => 'chains',                             'equals' => '22.0 yd'},
  {'type' => 'length', 'name' => 'furlong',       'alias' => 'furlongs',                           'equals' => '10.0 chains'},
  {'type' => 'length', 'name' => 'mile',          'alias' => 'miles',          "abbrev" => 'mi',    'equals' => '8.0 furlongs'},
  {'type' => 'unit', 'name' => 'acre',          'alias' => 'acres',                                'equals' => '10 square_chain'},
  {'type' => 'unit', 'name' => 'fluid_ounce',   'alias' => 'fluid_ounces',   "abbrev" => 'fl_oz', 'equals' => '2.8413062e-2 dm**3'},
  {'type' => 'unit', 'name' => 'gill',          'alias' => 'gills',                              'equals' => '5.0 fl_oz'},
  {'type' => 'unit', 'name' => 'pint',          'alias' => 'pints',          "abbrev" => 'pt',    'equals' => '4.0 gills'},
  {'type' => 'unit', 'name' => 'quart',         'alias' => 'quarts',         "abbrev" => 'qt',    'equals' => '2.0 pt'},
  {'type' => 'unit', 'name' => 'gallon',        'alias' => 'gallons',        "abbrev" => 'gal',   'equals' => '4.0 qt'},
  {'type' => 'unit', 'name' => 'grain',         'alias' => 'grains',         "abbrev" => 'gr',    'equals' => '6.479891e-5 kg'},
  {'type' => 'unit', 'name' => 'ounce',         'alias' => 'ounces',         "abbrev" => 'oz',    'equals' => '437.5 gr'},
  {'type' => 'unit', 'name' => 'pound',         'alias' => 'pounds',         "abbrev" => 'lb',    'equals' => '16.0 oz'},
  {'type' => 'unit', 'name' => 'stone',         'alias' => 'stones',                             'equals' => '14.0 lb'},
  {'type' => 'unit', 'name' => 'hundredweight', 'alias' => 'hundredweights', "abbrev" => 'cwt',   'equals' => '8.0 stone'},
  {'type' => 'unit', 'name' => 'long_ton',      'alias' => 'long_tons',      "abbrev" => 'lt',    'equals' => '20.0 cwt'}
]

US_BASE = [
  {'type' => 'import', 'file' => 'si/base'},
  {'type' => 'length', 'name' => 'inch',          'alias' => 'inches',         "abbrev" => 'in',    'equals' => '2.54 cm'},
  {'type' => 'length', 'name' => 'foot',          'alias' => 'feet',           "abbrev" => 'ft',    'equals' => '12.0 in'},
  {'type' => 'length', 'name' => 'yard',          'alias' => 'yards',          "abbrev" => 'yd',    'equals' => '3.0 ft'},
  {'type' => 'length', 'name' => 'furlong',       'alias' => 'furlongs',                           'equals' => '220.0 yd'},
  {'type' => 'length', 'name' => 'mile',          'alias' => 'miles',          "abbrev" => 'mi',    'equals' => '8.0 furlongs'},
  {'type' => 'unit', 'name' => 'acre',          'alias' => 'acres',                                'equals' => '4840.0 sq_yd'},
  {'type' => 'unit', 'name' => 'section',       'alias' => 'sections',                             'equals' => '1.0 sq_mi'},
  {'type' => 'unit', 'name' => 'township',      'alias' => 'townships',                            'equals' => '36.0 sections'},
  {'type' => 'unit', 'name' => 'fluid_ounce',   'alias' => 'fluid_ounces',   "abbrev" => 'fl_oz', 'equals' => '2.95735295625e-2 dm**3'},
  {'type' => 'unit', 'name' => 'gill',          'alias' => 'gills',                              'equals' => '4.0 fl_oz'},
  {'type' => 'unit', 'name' => 'pint',          'alias' => 'pints',          "abbrev" => 'pt',    'equals' => '4.0 gills'},
  {'type' => 'unit', 'name' => 'quart',         'alias' => 'quarts',         "abbrev" => 'qt',    'equals' => '2.0 pt'},
  {'type' => 'unit', 'name' => 'gallon',        'alias' => 'gallons',        "abbrev" => 'gal',   'equals' => '4.0 qt'},
  {'type' => 'unit', 'name' => 'grain',         'alias' => 'grains',         "abbrev" => 'gr',    'equals' => '6.479891e-5 kg'},
  {'type' => 'unit', 'name' => 'ounce',         'alias' => 'ounces',         "abbrev" => 'oz',    'equals' => '437.5 gr'},
  {'type' => 'unit', 'name' => 'pound',         'alias' => 'pounds',         "abbrev" => 'lb',    'equals' => '16.0 oz'},
  {'type' => 'unit', 'name' => 'stone',         'alias' => 'stones',                             'equals' => '14.0 lb'},
  {'type' => 'unit', 'name' => 'hundredweight', 'alias' => 'hundredweights', "abbrev" => 'cwt',   'equals' => '100.0 lb'},
  {'type' => 'unit', 'name' => 'short_ton',     'alias' => 'short_tons',     "abbrev" => 'st',    'equals' => '20.0 cwt'}
]

BINARY_BASE = [
  {'type' => 'binary', 'name' => 'bit',  'alias' => 'bits',  "abbrev" => 'b'},
  {'type' => 'binary', 'name' => 'byte', 'alias' => 'bytes', "abbrev" => 'B', 'equals' => '8.0 b'}
]

BINARY_EXTRA = [
  {'type' => 'import', 'file' => 'binary/base'},
  {'type' => 'unit', 'name' => 'x',  "abbrev" => '150 kB/s'}
]

OTHER = [
  {'type' => 'unit', 'name' => 'percent', 'equals' => '0.01'}
]

XMETHODS = {
  :mapping => {
    #'afa' => 'afghanistan', # Returns 0
    'all' => 'albania',
    'dzd' => 'algeria',
    'ars' => 'argentina',
    'aud' => 'australia',
    'ats' => 'austria',
    
    #'bsd' => 'bahamas', # Not supported
    'bhd' => 'bahrain',
    'bdt' => 'bangladesh',
    'bbd' => 'barbados',
    'bef' => 'belgium',
    'bmd' => 'bermuda',
    'brl' => 'brazil',
    #'bgn' => 'bulgaria', # Not supported
    
    'cad' => 'canada',
    'clp' => 'chile',
    'cny' => 'china',
    'cop' => 'colombia',
    'crc' => 'costa rica',
    'hrk' => 'croatia',
    'cyp' => 'cyprus',
    'czk' => 'czech republic',
    
    'dkk' => 'denmark',
    'dop' => 'dominican republic',
    
    'xcd' => 'east caribbean',
    'egp' => 'egypt',
    'eek' => 'estonia',
    'eur' => 'euro',
    
    #'fjd' => 'fiji', # Returns 0
    'fim' => 'finland',
    'frf' => 'france',
    
    'dem' => 'germany',
    'grd' => 'greece',
    
    'hkd' => 'hong kong',
    'huf' => 'hungary',
    
    'isk' => 'iceland',
    'inr' => 'india',
    'idr' => 'indonesia',
    #'irr' => 'iran', # Not supported
    #'iqd' => 'iraq', # Returns 0
    'iep' => 'ireland',
    'ils' => 'israel',
    'itl' => 'italy',
    
    'jmd' => 'jamaica',
    'jpy' => 'japan',
    'jod' => 'jordan',
    
    'kes' => 'kenya',
    'krw' => 'korea',
    'kwd' => 'kuwait',
    
    'lbp' => 'lebanon',
    'luf' => 'luxembourg',
    
    'myr' => 'malaysia',
    'mtl' => 'malta',
    'mur' => 'mauritius',
    'mxn' => 'mexico',
    'mad' => 'morocco',
    
    'nlg' => 'netherlands',
    'nzd' => 'new zealand',
    'nok' => 'norway',
    
    'omr' => 'oman',
    
    'pkr' => 'pakistan',
    'pen' => 'peru',
    'php' => 'philippines',
    'pln' => 'poland',
    'pte' => 'portugal',
    
    'qar' => 'qatar',
    
    'ron' => 'romania',
    'rub' => 'russia',
    
    'sar' => 'saudi arabia',
    'sgd' => 'singapore',
    'skk' => 'slovakia',
    'sit' => 'slovenia',
    'zar' => 'south africa',
    'esp' => 'spain',
    'lkr' => 'sri lanka',
    'sdd' => 'sudan',
    'sek' => 'sweden',
    'chf' => 'switzerland',
    
    'twd' => 'taiwan',
    'thb' => 'thailand',
    'ttd' => 'trinidad',
    'tnd' => 'tunisia',
    #'try' => 'turkey', # Returns 0
    
    'aed' => 'united arib emirates', # This is obviously mispelled
    'gbp' => 'united kingdom',
    'usd' => 'united states',
    
    'veb' => 'venezuela',
    'vnd' => 'vietnam',
    
    'zmk' => 'zambia'
  },
  :base => 'ron'
}

CURRENCIES = ['aed', 'afa', 'all', 'ars', 'ats', 'aud', 'bbd', 'bdt', 'bef', 'bgn', 'bhd', 'bmd', 'brl', 'bsd', 'cad', 'chf', 'clp', 'cny', 'cop', 'crc', 'cyp', 'czk', 'dem', 'dkk', 'dop', 'dzd', 'eek', 'egp', 'esp', 'eur', 'fim', 'fjd', 'frf', 'gbp', 'grd', 'hkd', 'hrk', 'huf', 'idr', 'iep', 'ils', 'inr', 'iqd', 'irr', 'isk', 'itl', 'jmd', 'jod', 'jpy', 'kes', 'krw', 'kwd', 'lbp', 'lkr', 'luf', 'mad', 'mtl', 'mur', 'mxn', 'myr', 'nlg', 'nok', 'nzd', 'omr', 'pen', 'php', 'pkr', 'pln', 'pte', 'qar', 'ron', 'rub', 'sar', 'sdd', 'sek', 'sgd', 'sit', 'skk', 'thb', 'tnd', 'try', 'ttd', 'twd', 'usd', 'veb', 'vnd', 'xcd', 'zar', 'zmk']

CURRENCY_BASE = CURRENCIES.map { |c| {'type' => 'currency', 'name' => c} }

driver = SOAP::WSDLDriverFactory.new("http://www.xmethods.net/sd/2001/CurrencyExchangeService.wsdl").createDriver
ron = XMETHODS[:mapping]['ron']

CACHED_RATES = {}

CURRENCIES.each do |name|
  country = XMETHODS[:mapping][name]
  rate = (driver.getRate(country, ron) rescue nil)
  puts "#{name} -> #{rate || 'X'}"
  CACHED_RATES[name] = rate if rate
end

DEFAULT = [
  {'type' => 'import', 'file' => 'si/derived'},
  {'type' => 'import', 'file' => 'si/extra'},
  {'type' => 'import', 'file' => 'us/base'},
  {'type' => 'import', 'file' => 'us/base'},
  {'type' => 'import', 'file' => 'binary/base'},
  {'type' => 'service', 'name' => 'XMethods'},
  {'type' => 'import', 'file' => 'currency/base'}
]

UK = [
  {'type' => 'import', 'file' => 'si/derived'},
  {'type' => 'import', 'file' => 'uk/base'},
  {'type' => 'import', 'file' => 'binary/base'},
  {'type' => 'service', 'name' => 'XMethods'},
  {'type' => 'import', 'file' => 'currency/base'}
]

US = [
  {'type' => 'import', 'file' => 'si/derived'},
  {'type' => 'import', 'file' => 'us/base'},
  {'type' => 'import', 'file' => 'binary/base'},
  {'type' => 'service', 'name' => 'XMethods'},
  {'type' => 'import', 'file' => 'currency/base'}
]

CEX = [
  {'type' => 'service', 'name' => 'CachedXMethods'},
  {'type' => 'import', 'file' => 'currency/base'}
]

STANDARD_CONVERTORS = [
  'default',
  'uk',
  'us',
  'cex'
]

File.open('share/units/si/base.yaml', 'w') { |f| f.puts SI_BASE.to_yaml }
File.open('share/units/si/derived.yaml', 'w') { |f| f.puts SI_DERIVED.to_yaml }
File.open('share/units/si/extra.yaml', 'w') { |f| f.puts SI_EXTRA.to_yaml }
File.open('share/units/uk/base.yaml', 'w') { |f| f.puts IMPERIAL_BASE.to_yaml }
File.open('share/units/us/base.yaml', 'w') { |f| f.puts US_BASE.to_yaml }
File.open('share/units/currency/base.yaml', 'w') { |f| f.puts CURRENCY_BASE.to_yaml }
File.open('share/units/binary/base.yaml', 'w') { |f| f.puts BINARY_BASE.to_yaml }
File.open('share/units/binary/extra.yaml', 'w') { |f| f.puts BINARY_EXTRA.to_yaml }

File.open('share/units/xmethods/mapping.yaml', 'w') { |f| f.puts XMETHODS.to_yaml }
File.open('share/units/xmethods/cached.yaml', 'w') { |f| f.puts CACHED_RATES.to_yaml }

File.open('share/units/default.yaml', 'w') { |f| f.puts DEFAULT.to_yaml }
File.open('share/units/us.yaml', 'w') { |f| f.puts US.to_yaml }
File.open('share/units/uk.yaml', 'w') { |f| f.puts UK.to_yaml }
File.open('share/units/cex.yaml', 'w') { |f| f.puts CEX.to_yaml }

File.open('share/units/standard.yaml', 'w') { |f| f.puts STANDARD_CONVERTORS.to_yaml }
