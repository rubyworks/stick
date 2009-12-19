module Stick
module Units

  # = NIST Metric Units
  #
  module SI
  end

end
end

base = Dir[File.join(File.dirname(__FILE__), 'si', 'base', '*.rb')]
derv = Dir[File.join(File.dirname(__FILE__), 'si', 'derived', '*.rb')]
(base + derv).each{ |file| require(file) }

