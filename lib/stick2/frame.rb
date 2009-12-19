module Stick
module Units

  # = Frame of Reference
  #
  # 
  #
  class Frame

    PI = 3.14159265358979323846264338327950288

    As = 10**33
    At = 10**42
    Am = 10**18  # Exa
    Aq = 10**18  # Exa
    Ao = 10**24  # Yotta

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
    end

    def S ; Math.sqrt(h * 8 * PI * g / c ** 3)          ; end
    def T ; Math.sqrt(h * 8 * PI * g / c ** 5)          ; end
    def M ; Math.sqrt(h * c / 8 * PI * g)               ; end
    def Q ; Math.sqrt(h * 4 * PI / c * u)               ; end
    def O ; Math.sqrt(h * c ** 5 / 2 * PI * g * k ** 2) ; end

    def Sa ; @Sa ||= self.S * As ; end
    def Ta ; @Ta ||= self.T * At ; end
    def Ma ; @Ma ||= self.M * Am ; end
    def Qa ; @Qa ||= self.Q * Aq ; end
    def Oa ; @Fa ||= self.O * Ao ; end

    def Sr ; @Sr ||= 1 / self.S * As ; end
    def Tr ; @Tr ||= 1 / self.T * At ; end
    def Mr ; @Mr ||= 1 / self.M * Am ; end
    def Qr ; @Qr ||= 1 / self.Q * Aq ; end
    def Or ; @Fr ||= 1 / self.O * Ao ; end

    def coefficients
      return self.Sa, self.Ta, self.Ma, self.Qa, self.Oa
    end

    def to_a
      return self.Sr, self.Tr, self.Mr, self.Qr, self.Or
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
end

