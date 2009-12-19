module Stick
module Units

  # = Anthropomorphic Natural Units
  #
  # Stick uses a set of standard units to handle conversions between
  # different unit systems. The system used for this purpose is
  # a natural units system, setting the natural constants as follows:
  #
  #   c = 1        Speed of Light
  #   h = 1        Planck's constant
  #   ε = 1/4 π    Electric Constant
  #   G = 1/8 π    Gravitational constant
  #   k = 2        Blotzman's Constant
  #
  # Consequently,
  #
  #   2 π ħ = 1
  #   4 π ε = 1
  #   8 π G = 1
  #
  # This system has only two base units, the transcendental aesthetic
  # Space (S) and Time (T).
  #
  #   S = (8 π G h / c^3) ^ 1/2
  #   T = (8 π G h / c^5) ^ 1/2
  #
  # While these two base units are all that are required to fully derive
  # system of natural units, it is helpful to elucidate three important
  # derived units, Mass (M), Charge (Q) and Temperature (H) as follows:
  #
  #   M = (h c / 8 π G) ^ 1/2
  #   Q = (h c 4 π ε) ^ 1/2
  #   H = (h c^5 / 2 π G K^2) ^ 1/2
  #
  # In SI units (metric) the about constants are:
  #
  #   c = 299,792,458           m        s-1
  #   h = 6.626068960 × 10^-34  m2  kg   s
  #   G = 6.674280000 × 10^-11  m3  kg-1 s-2
  #   ε = 8.854187817 × 10^-12  m-3 kg-1 s4  A2 
  #   k = 1.380650300 × 10^-23  m2  kg   s-2 K-1
  #
  # Giving us the conversion values for our units as:
  #
  #   S = 2.03104273895475e-34 m
  #   T = 6.77482933528218e-43 s
  #   M = 2.28176272483924e-18 kg
  #   Q = 4.70129630762420e-18 C
  #   H = 5.66272675153234e-24 K
  #
  # We then apply athropomorphic factors to each to bring
  # them into the useful range of us mortals:
  #
  #   As = 10^33 (Fre?)  ;)
  #   At = 10^42 (Ada?)  ;)
  #   Am = 10^18 (Exa)
  #   Aq = 10^18 (Exa)
  #   Ah = 10^24 (Yotta)
  #
  # And arrive at our final conversions:
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
  module AU

    PI = 3.14159265358979323846264338327950288

    # SI Metric conversion

    C = 299792458.0     # m s-1
    G = 6.67428e-11     # m3 kg-1 s-2
    P = 6.62606896e-34  # m2 kg / s      (Planck's constant)
    E = 8.854187817e-12 # F m-1
    K = 1.3806504e-23   # J K-1

    S = Math.sqrt(P * 8 * PI * G / C ** 3)
    T = Math.sqrt(P * 8 * PI * G / C ** 5)
    M = Math.sqrt(P * C / 8 * PI * G)
    Q = Math.sqrt(P * C * 4 * PI * E)
    H = Math.sqrt(P * C**5 / 2 * PI * G * K**2)

    As = 10**33
    At = 10**42
    Am = 10**18  # Exa
    Aq = 10**18  # Exa
    Ah = 10**24  # Yotta

    Sa = S * As
    Ta = T * At
    Ma = M * Am
    Qa = Q * Aq
    Ha = H * Ah

    # = AU Unit
    #
    class Unit < Stick::Unit

      #
      def to_au
        self
      end

      #
      def self.from_au(unit)
        raise ArgumentError, "requires #{self}" unless self === unit
        unit
      end

    end

  end

end
end

base = Dir[File.join(File.dirname(__FILE__), 'au', 'base', '*.rb')]
derv = Dir[File.join(File.dirname(__FILE__), 'au', 'derived', '*.rb')]
(base + derv).each{ |file| require(file) }


# special use

if $0 == __FILE__

   include Stick::Units::AU

   p S, T, M, Q, H
   puts
   puts "#{Sa} m", "#{Ta} s", "#{Ma} kg", "#{Qa} C", "#{Ha} K" 
   puts
   p 1/Sa, 1/Ta, 1/Ma, 1/Qa, 1/Ha

end

