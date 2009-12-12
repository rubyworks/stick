module Stick

  # = Math Extensions
  #
  # These functions were derived from Extmath v2.3.
  #
  # Extmath, Copyright (c) 2003 Josef 'Jupp' Schugt <jupp@rubyforge.org>
  #
  # This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
  # published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
  # 
  # This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
  # 
  # You should have received a copy of the GNU General Public License along with this program; if not, write to the
  # Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.

  # == Constants
  #  +C+, +E+, +PI+
  #
  # == Methods
  # * Powers and roots
  #   +pow+, +root+, +sqr+, +sqrt+
  # * Exponential and logarithmic functions
  #   +exp+, +exp10+, +exp2+, +frexp+, +ldexpldexp+, +loglog+, +log10log10+, +log2log2+
  # * Special functions
  #   +beta+, +erf+, +erfc+, +lgamma+, +sinc+, +tgamma+
  # * Absolute value, sign and rounding
  #   +abs+, +ceil+, +floor+, +round+, +sign+
  # * Integer functions
  #   +delta+, +epsilon+, +factorial+, +gcd+, +lcm+
  # * Solver
  #   +linsolve+, +sqsolve+ ]
  #
  module Math
    include ::Math
    extend self

    Inv_ln_2	   = 1.0 / ::Math.log(2.0)
    Gauss_factor = ::Math.sqrt(0.5 / Math::PI)

    Factorials = [ 
      1,
      1,
      2,
      6,
      24,
      120,
      720,
      5_040,
      40_320,
      362_880,
      3_628_800,
      39_916_800,
      479_001_600,
      6_227_020_800,
      87_178_291_200,
      1_307_674_368_000
    ]

    # Euler's constant <code>C</code>, <code>Extmath.C = 0.577_2...</code>
    C = 0.577_215_664_901_532_861

    # Same as <code>Math::E</code> - Euler's number, <code>Extmath.E = 2.718_182_8...</code>
    E = ::Math::E

    # Absolute value of +x+
    def abs(x)
      x.abs
    end

    # Beta function of +x+ and +y+ - <code>beta(+x+, +y+) =
    # tgamma(+x+) * tgamma(+y+) / tgamma(+x+ + +y+)</code>
    def beta(x, y)
      Math.exp(Extmath.lgamma(x) + Extmath.lgamma(y) - Extmath.lgamma(x+y))
    end

    # Smallest integer not smaller than +x+
    def ceil(x)
      x.ceil
    end

    # Kronecker symbol of +i+ and +j+ - 1 if +i+ and +j+ are equal, 0 otherwise
    def delta(i, j)
      return Integer(i) == Integer(j) ? 1 : 0
    end

    # Levi-Civita symbol of +i+, +j+, and +k+ - 1 if (+i+, +j+, +k+) is (1, 2, 3), (2, 3, 1), or (3, 1, 2),
    # -1 if it is (1, 3, 2), (2, 1, 3), or (3, 2, 1), 0 as long as +i+, +j+, and +k+ are all elements of {1, 2, 3},
    # otherwise returns <code>nil</code>.
    def epsilon(i, j, k)
      i = Integer(i)
      return nil if i < 1 or i > 3
      j = Integer(j)
      return nil if j < 1 or j > 3
      k = Integer(k)
      return nil if k < 1 or k > 3
      case i * 16 + j * 4 + k
        when 27, 45, 54 then return  1
        when 30, 39, 57 then return -1
      end
      0
    end

    # Same as <code>Math.erf(+x+)</code> - Gauﬂian error integral up to +x+
    def erf(x)
      ::Math.erf(x)
    end

    # Same as <code>Math.erfc(+x+)</code> - complementary Gauﬂian error integral from +x+ on
    def erfc(x)
      ::Math.erfc(x)
    end

    # Same as <code>Math.exp(+x+)</code> - e to the power +x+
    def exp(x)
      ::Math.exp(x)
    end

    # 10 to the power +x+
    def exp10(x)
      10.0 ** x
    end

    # 2 to the power +x+
    def exp2(x)
      2.0 ** x
    end

    # 1 * 2 * ... * +n+, <code>nil</code> for negative numbers
    def factorial(n)
      n = Integer(n)
      if n < 0
        nil
      elsif Factorials.length > n
        Factorials[n]
      else
        h = Factorials.last
        (Factorials.length .. n).each { |i| Factorials.push h *= i }
        h
      end
    end

    # Largest integer not larger than +x+
    def floor(x)
      x.floor
    end

    # Same as <code>Math.frexp(+x+)</code> - two-element array containing the normalized fraction and exponent of +x+.
    def frexp(x)
      Math.frexp(x)
    end

    # Greatest common divisor of +m+ and +n+, <code>nil</code> for non-positive numbers - gcd is computed by means of the Euklidian
    # algorithm
    def gcd(m, n)
      m = Integer(m)
      n = Integer(n)
      if m <= 0 || n <= 0
        return nil
      end
      loop {
        if m < n
          m, n = n, m
        end
        if (l = m % n) == 0
          break
        end
        m = l
      }
      n
    end

    # Least common multiple of +m+ and +n+ - computed by multiplying +m+ and +n+ and dividing the product by the gcd
    # of +m+ and +n+, <code>nil</code> for non-positive numbers.
    def lcm(m, n)
      m = Integer(m)
      n = Integer(n)
      if m <= 0 || n <= 0
        return nil
      end
      m / gcd(m, n) * n
    end

    # +x+ times 2 to the power +y+
    def ldexp(x, y)
      Math.ldexp(x, y)
    end

    # Logarithmus naturalis of gamma function of +x+
    def lgamma(x)
      h  = x + 5.5
      h -= (x + 0.5) * log(h)
      sum  =  1.000_000_000_190_015
      sum += 76.180_091_729_471_46	     / (x + 1.0)
      sum -= 86.505_320_329_416_77	     / (x + 2.0)
      sum += 24.014_098_240_830_91	     / (x + 3.0)
      sum -=  1.231_739_572_450_155	     / (x + 4.0)
      sum +=  0.120_865_097_386_617_9e-2 / (x + 5.0)
      sum -=  0.539_523_938_495_3e-5     / (x + 6.0)
      -h + log(2.506_628_274_631_000_5 * sum / x)
    end

    # Returns real solution(s) of <code>+a+x + +b+ = +c+</code> or <code>nil</code> if no or an infinite number of solutions exist. If
    # <code>c</code> is missing it is assumed to be 0.
    def linsolve(a, b, c = 0.0)
      a == 0 ? nil : (c - b) / a
    end

    # Same as <code>Math.log(+x+)</code> - logarithmus naturalis of +x+
    def log(x)
      Math.log(x)
    end

    # Same as <code>Math.log10(+x+)</code> - logarithmus decimalis of +x+
    def log10(x)
      Math.log10(x)
    end

    # Logarithmus dualis of +x+
    def log2(x)
      Math.log(x) * Inv_ln_2
    end

    # +x+ to the power +y+
    def pow(x, y)
      x ** y
    end

    # Extmath.rad2deg(x)
    # Converts +x+ form radian to degree
    def rad2deg(x)
      return Rad2deg * x
    end

    # Converts +x+ form radian to gon.
    def rad2gon(x)
      return Rad2gon * x
    end

    # The +y+ root of +x+.
    def root(x, y)
      x ** (1.0 / y)
    end

    # +x+ rounded to nearest integer
    def round(x)
      x.round
    end

    # Sign of +x+.
    # Returns -1 for negative x, +1 for positive x and zero for x = 0 
    def sign(x)
      (x > 0.0) ? 1.0 : ((x < 0.0) ? -1.0 : 0.0)
    end

    # Square of number.
    #
    def sqr(x)
      x * x
    end

    #
    def sqrt(x)
      ::Math.sqrt(x)
    end

    # Returns array of real solution of <code>ax**2 + bx + c = d</code>
    # or <code>nil</code> if no or an infinite number of solutions exist.
    # If +d+ is missing it is assumed to be 0.
    #
    # == Solving second order equations
    # In order to solve <code>ax**2 + bx + c = d</code> +Extmath.sqsolve+ identifies several cases:
    # * <code>a == 0:</code>
    #   The equation to be solved is the linear equation <code>bx + c = d</code>. #sqsolve> delegates the computation to
    #   #linsolve>. If it results in +nil+, +nil+ is returned (not <code>[nil]</code>!). Otherwise a one-element array
    #   containing result of #linsolve is returned.
    # * <code>a != 0:</code>
    #    The equation to be solved actually is a second order one.
    #    * <code>c == d</code>
    #      The equation to be solved is <code>ax**2 + bx = 0</code>. One solution of this equation obviously is
    #      <code>x = 0</code>, the second one solves <code>ax + b = 0</code>. The solution of the latter is
    #      delegated to +Extmath.linsolve+. An array containing both results in ascending order is returned.
    #    * <code>c != d</code>
    #      The equation cannot be separated into <code>x</code> times some factor.
    #      * <code>b == 0</code>
    #        The equation to be solved is <code>ax**2 + c = d</code>. This can be written as the linear equation
    #        <code>ay + c = d</code> with <code>y = x ** 2</code>. The solution of the linear equation is delegated
    #        to +Extmath.linsolve+. If the returned value for +y+ is +nil+, that becomes the overall return value.
    #        Otherwise an array containing the negative and positive squareroot of +y+ is returned
    #      * <code>b != 0 </code>
    #        The equation cannot be reduced to simpler cases. We now first have to compute what is called the
    #        discriminant <code>x = b**2 + 4a(d - c)</code> (that's what we need to compute the square root of).
    #        If the descriminant is negative no real solution exists and <code>nil</code> is returned. The ternary
    #        operator checking whether <code>b</code> is negative does ensure better numerical stability --only one
    #        of the two solutions is computed using the widely know formula for solving second order equations.
    #        The second one is computed from the fact that the product of both solutions is <code>(c - d) / a</code>.
    #        Take a look at a book on numerical mathematics if you don't understand why this should be done.
    #
    def sqsolve(a, b, c, d = 0.0)
      if a == 0.0
        x = linsolve(b, c, d)
        return x.nil? ? nil: [ linsolve(b, c, d) ]
      else
        return [0.0, linsolve(a, b)].sort if c == d
        if b == 0.0
          x = Extmath.linsolve(a, c, d)
          x < 0.0 ? nil : [-Math.sqrt(x), Math.sqrt(x)]
        else
          x = b * b + 4.0 * a * (d - c)
          return nil if x < 0.0
          x = b < 0 ? b - Math.sqrt(x) : b + Math.sqrt(x)
          [-0.5 * x / a, 2.0 * (d - c) / x].sort
        end
      end
    end

    #
    def gamma(x)
      exp(lgamma(x))
    end

  end

end


module Math #:nodoc:
  include Stick::Math
end

