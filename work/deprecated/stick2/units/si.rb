module Stick
module Units

  module SI

    #PREFIXES = [
    #  [ 'kilo', 'k', 10e3 ],
    #  [ 'mega', 'M', 10e6 ],
    #  [ 'giga', 'G', 10e9 ]
    #]

  end

end
end

base = Dir[File.join(File.dirname(__FILE__), 'si', 'base', '*.rb')]
derv = Dir[File.join(File.dirname(__FILE__), 'si', 'derived', '*.rb')]
(base + derv).each{ |file| require(file) }

