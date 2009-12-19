module Stick
module Units
module AU

  # I = Q / t
  class Current < Unit

    SYMBOL = 'I'
    TYPE   = :current

    def to_base
      ComplexUnit.new(value, Charge.new(1, power), Time.new(1, -power))
    end

  end

end
end
end

