module Stick

  #
  module Trigonometry

    #
    module Math
    
      # Same as <code>Math::PI</code> - Ludolph's number, <code>PI = 3.141_59..</code>.
      PI = ::Math::PI

      PI_by_2 = 0.5 * PI

      # Same as <code>Math.acos(+x+)</code> - arcus cotangens of +x+
      def acos(x)
        Math.acos(x)
      end

      # Same as <code>Math.acosh(+x+)</code> - area cosinus hyperbolicus of +x+
      def acosh(x)
        Math.acosh(x)
      end

      # Arcus cotangens of +x+
      def acot(x)
        PI_by_2 - ::Math.atan(x)
      end

      # Area cotangens hyperbolicus of +x+
      def acoth(x)
        0.5 * ::Math.log((x + 1.0) / (x - 1.0))
      end

      # Arcus cosecans of +x+
      def acsc(x)
        Math.asin(1.0 / x)
      end

      # Area cosecans hyperbolicus of +x+
      def acsch(x)
        Math.log(1.0 / x + Math.sqrt(1.0 + 1.0 / (x * x)))
      end

      # Arcus secans of +x+
      def asec(x)
        Math.acos(1.0 / x)
      end

      # Area secans hyperbolicus of +x+
      def asech(x)
        Math.log((1.0 + ::Math.sqrt(1.0 - x * x)) / x)
      end

      # Same as <code>Math.asin(+x+)</code> - arcus sinus of +x+
      def asin(x)
        Math.asin(x)
      end

      # Same as <code>Math.sinh(+x+)</code> - area sinus hyperbolicus of +x+
      def asinh(x)
        Math.asinh(x)
      end

      # Arcus tangens of +x+.
      def atan(x)
        Math.atan(x)
      end

      # Arcus tangens of +x+ over +y+.
      def atan2(x, y)
        Math.atan2(x, y)
      end

      # Same as <code>Math.atanh(+x+)</code> - area tangens hyperbolicus of +x+
      def atanh(x)
        Math.atanh(x)
      end

      # Same as <code>Math.cos(+x+)</code> - cosinus of +x+
      def cos(x)
        Math.cos(x)
      end

      # Same as <code>Math.cosh(+x+)</code> - cosinus hyperbolicus of +x+
      def cosh(x)
        Math.cosh(x)
      end

      # Cotangens of +x+
      def cot(x)
        Math.tan(PI_by_2 - x)
      end

      # Cotangens hyperbolicus of +x+
      def coth(x)
        1.0 / ::Math.tanh(x)
      end

      # Cosecans of +x+
      def csc(x)
        1.0 / ::Math.sin(x)
      end

      # Cosecans hyperbolicus of +x+
      def csch(x)
        1.0 / Math.sinh(x)
      end

      # Secans of +x+.
      def sec(x)
        1.0 / ::Math.cos(x)
      end

      # Secans hyperbolicus of +x+
      def sech(x)
        1.0 / ::Math.cosh(x)
      end

      # Sin of x.
      def sin(x)
        ::Math.sin(x)
      end

      # Sinc function of +x+.
      #
      def sinc(x)
        (x == 0.0) ? 1.0 : ::Math.sin(x) / x
      end

      # Sin hyperbolicus of +x+.
      def sinh(x)
        ::Math.sinh(x)
      end

      #
      def tan(x)
        ::Math.tan(x)
      end

      #
      def tanh(x)
        ::Math.tanh(x)
      end

    end #module Math

  end #module Trigonometry

end #module Stick

module Math #:nodoc:
  extend  Trigonometry::Math
  include Trigonometry::Math
end

