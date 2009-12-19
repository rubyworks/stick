module Stick
module Units

  module US
    #PREFIXES = [
    #  [ 'kilo', 'k', 10e3 ],
    #  [ 'mega', 'M', 10e6 ],
    #  [ 'giga', 'G', 10e9 ]
    #]
  end

end
end

base = Dir[File.join(File.dirname(__FILE__), 'us', 'base', '*.rb')]
derv = Dir[File.join(File.dirname(__FILE__), 'us', 'derived', '*.rb')]
(base + derv).each{ |file| require(file) }

