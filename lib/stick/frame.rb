module Stick

  # = Frame of Reference
  #
  # Stick uses a set of standard units, the Anthropomorphic Natural
  # Units (AU), to handle conversions between different unit systems.
  # The system used for this purpose is a natural units system,
  # setting the natural constants as follows:
  #
  #   c = 1        Speed of Light
  #   h = 1        Planck's constant
  #   u = 1        Magnetic constant
  #   G = 1/8 π    Gravitational constant
  #   k = 2        Blotzman's Constant
  #
  # Consequently,
  #
  #   2 π ħ = 1
  #   8 π G = 1
  #
  # Technically the system needs only two base units, the transcendental
  # aesthetics Space (S) and Time (T).
  #
  #   S = (8 π G h / c^3) ^ 1/2
  #   T = (8 π G h / c^5) ^ 1/2
  #
  # While these two units are all that are required to fully derive
  # system of natural units, it is practical to include three important
  # derived units, Mass (M), Charge (Q) and Temperature (H) as follows:
  #
  #   M = (h c / 8 π G) ^ 1/2
  #   Q = (h 4 π / u c) ^ 1/2
  #   H = (h c^5 / 8 π G k^2) ^ 1/2
  #
  # Now we nedd to anthropomorphize these units so they useful at human scale.
  # We do this by applying a <i>anthropomorphic scaling factor</i> to each.
  # If we consider these values in metric (SI units) the constants are:
  #
  #   c = 299,792,458           m        s-1
  #   h = 6.626068960 × 10^-34  m2  kg   s
  #   G = 6.674280000 × 10^-11  m3  kg-1 s-2
  #   ε = 8.854187817 × 10^-12  m-3 kg-1 s4  A2 
  #   k = 1.380650300 × 10^-23  m2  kg   s-2 K-1
  #
  # We get the conversion values for our units as:
  #
  #   S = 2.03104273895475e-34 m
  #   T = 6.77482933528218e-43 s
  #   M = 2.28176272483924e-18 kg
  #   Q = 4.70129630762420e-18 C
  #   H = 5.66272675153234e-24 K
  #
  # Cleary too small for practical use. But useful to as a frame of reference for
  # determining suitable athropomorphic factors.
  #
  #   As = 10^33 (Fre?)  ;)
  #   At = 10^42 (Ada?)  ;)
  #   Am = 10^18 (Exa)
  #   Aq = 10^18 (Exa)
  #   Ah = 10^24 (Yotta)
  #
  # Which gives us out final conversion formulas:
  #
  #   S = (8 π G h / c^3) ^ 1/2      * 10^33
  #   T = (8 π G h / c^5) ^ 1/2      * 10^42
  #   M = (h c / 8 π G) ^ 1/2        * 10^18
  #   Q = (h c 4 π ε) ^ 1/2          * 10^18
  #   H = (h c^5 / 2 π G K^2) ^ 1/2  * 10^24
  # 
  # And in metric, the final conversion ratios:
  #
  #   S = 0.203104273895475 m
  #   T = 0.677482933528218 s
  #   M = 2.281762724839240 kg
  #   Q = 4.701296307624200 C
  #   H = 5.662726751532340 K
  #
  # Or conversely,
  #
  #   1 m  = 4.923579306433680 S
  #   1 s  = 1.476051942433690 T
  #   1 kg = 0.438257663303030 M
  #   1 C  = 0.212707290620733 Q
  #   1 K  = 0.176593369921902 H
  #
  class Frame

    PI = 3.14159265358979323846264338327950288

    As = 10**33
    At = 10**42
    Am = 10**18  # Exa
    Aq = 10**18  # Exa
    Ao = 10**24  # Yotta
    Ae = 10**24  # Yotta

    # Speed of light
    attr :c

    # Gravitational constant
    attr :g

    # Planck's constant
    attr :h

    # Magnetic constant (vacuum permeability)
    attr :u

    # Boltzmann's constant
    attr :k

    #
    def initialize(c, g, h, u, k)
      @c, @g, @h, @u, @k = c, g, h, u, k

      @S = Math.sqrt(h * 8 * PI * g / c ** 3)
      @T = Math.sqrt(h * 8 * PI * g / c ** 5)
      @M = Math.sqrt(h * c / 8 * PI * g)
      @Q = Math.sqrt(h * 4 * PI / c * u)
      @O = Math.sqrt(h * c ** 5 / 2 * PI * g * k ** 2)
      @E = Math.sqrt(h * c ** 5 / 2 * PI * g)
    end

    #
    def A(symbol)
      __send__("#{symbol}a")
    end

    #def S ; Math.sqrt(h * 8 * PI * g / c ** 3)          ; end
    #def T ; Math.sqrt(h * 8 * PI * g / c ** 5)          ; end
    #def M ; Math.sqrt(h * c / 8 * PI * g)               ; end
    #def Q ; Math.sqrt(h * 4 * PI / c * u)               ; end
    #def O ; Math.sqrt(h * c ** 5 / 2 * PI * g * k ** 2) ; end
    #def E ; Math.sqrt(h * c ** 5 / 2 * PI * g)          ; end

    def Sa ; @Sa ||= @S * As ; end
    def Ta ; @Ta ||= @T * At ; end
    def Ma ; @Ma ||= @M * Am ; end
    def Qa ; @Qa ||= @Q * Aq ; end
    def Oa ; @Oa ||= @O * Ao ; end
    def Ea ; @Oa ||= @E * Ae ; end

    def rada ; 1; end

    def Sr ; @Sr ||= 1 / @S * As ; end
    def Tr ; @Tr ||= 1 / @T * At ; end
    def Mr ; @Mr ||= 1 / @M * Am ; end
    def Qr ; @Qr ||= 1 / @Q * Aq ; end
    def Or ; @Or ||= 1 / @O * Ao ; end
    def Er ; @Or ||= 1 / @E * Eo ; end

    def coefficients
      return self.Sa, self.Ta, self.Ma, self.Qa, self.Oa, self.Ea
    end

    def to_a
      return self.Sr, self.Tr, self.Mr, self.Qr, self.Or, self.Er
    end
  end


  # TODO: Make these reusable formula
  #S = Math.sqrt(P * 8 * PI * G / C ** 3)
  #T = Math.sqrt(P * 8 * PI * G / C ** 5)
  #M = Math.sqrt(P * C / 8 * PI * G)
  #Q = Math.sqrt(P * C * 4 * PI * E)
  #H = Math.sqrt(P * C**5 / 2 * PI * G * K**2)

  #Sa = S * As
  #Ta = T * At
  #Ma = M * Am
  #Qa = Q * Aq
  #Ha = H * Ah

end

