module Stick
module Units

  class Prefix

    # Long form of prefix, eg. "mega".
    attr :long

    # Short form of prefix, eg. "M".
    attr :short

    # Mulitplicative factor, eg 10e6.
    attr :factor

    #
    def initialize(long, short, factor)
      @long   = long
      @short  = short
      @factor = factor
    end

  end

end
end

