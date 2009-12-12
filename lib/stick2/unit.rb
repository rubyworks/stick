module Stick

  # A unit is a compound of base units.
  class Unit

    attr :bases

    # A unit is a compound of base units.
    def initialize(*bases)
      @bases = bases.flatten
    end

    #  
    def each(&block)
      @bases.each(&block)
    end

    #
    def size
      @bases.size
    end

    #
    def to_lcm
      Unit.new(*bases.map{ |b| b.to_lcm })
    end

    #
    def invert
      Unit.new(*bases.map{ |b| b.invert })
    end

    #
    def to_s
      bases.map{ |b| b.to_s }.join(" ")
    end

    #
    def ==(other)
      bases == other.bases
    end

  end

end

