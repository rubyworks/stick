require 'stick/units/base'
require 'soap/wsdlDriver'

module Stick
module Units

  class CurrencyLoader < Loader
    THREAD_REFERENCE = 'Units::ce_service'.to_sym

    handles 'ce_service', 'currency_unit'

    def ce_service(converter, name, &blk)
      old_service = Thread.current[THREAD_REFERENCE]
      Thread.current[THREAD_REFERENCE] = Units::Converter::ExchangeRate.const_get(name)
      yield
    ensure
      Thread.current[THREAD_REFERENCE] = old_service
    end

    def currency_unit(converter, name)
      service = Thread.current[THREAD_REFERENCE] || Units::Config::DEFAULT_CURRENCY_SERVICE
      converter.send(:register_unit, name, :equals => service.create_conversion(name, converter))
    end
  end

  class Converter

    # Encapsulates a service for retrieving exchange rates.
    # This is used by Converter.register_currency.
    # An instance of this class behaves like a Numeric when used
    # in calculations. This class is used to look up exchange rates
    # lazily.
    #
    # This class is not supposed to be instantiated by itself. Instead a
    # subclass should be created that defines the method +get_rate+.
    # The only subclasses provided are currently XMethods and CachedXMethods.
    #
    # To be found automatically from YAML files, exchange services should
    # be located under Units::Converter::ExchangeRate.
    class ExchangeRate

      def self.create_conversion(curr, converter) # :nodoc:
        {:unit => Units::Unit.new({'--base-currency--'.to_sym => 1}, converter), :multiplier => self.new(curr)}
      end

      def initialize(curr) # :nodoc:
        @curr = curr
      end

      # This method should be overridden in subclasses to return the
      # exchange rate represented by this object. The unit in question
      # is available as a String in the instance variable <code>@curr</code>.
      # The rate should be calculated against an arbitrary but fixed base currency.
      # The rate should be such that the following would be true
      #   1 * curr = rate * base_curr
      # This function should return +nil+ if the currency is not supported by this
      # retrieval service. It should <em>not</em> raise an exception.
      def get_rate
        raise NoMethodError, "undefined method `get_rate' for #{to_s}:#{self.class}"
      end

      def value # :nodoc:
        @value ||= get_rate or raise TypeError, "currency not supported by current service: #{@curr.to_s.dump}"
      end

      def coerce(other) # :nodoc:
        [value, other]
      end

      def *(other) # :nodoc:
        value * other
      end

      def /(other) # :nodoc:
        value / other
      end

      def +(other) # :nodoc:
        value + other
      end

      def -(other) # :nodoc:
        value - other
      end

      def **(other) # :nodoc:
        value ** other
      end

      # Exchange rate retrieval service that uses a service from http://www.xmethods.com.
      # See http://rubyurl.com/7uq.
      class XMethods < ExchangeRate

        # This is the only method that a subclass of ExchangeRate
        # needs to implement. This is a good example to follow.
        def get_rate
          driver.getRate(country_mapping[@curr], country_mapping[base])
        rescue
          p $!
          puts $!.backtrace
          nil
        end

        private

        def data
          @@data ||= eval(File.read(File.join(Units::Config::CONFIGDIR, 'xmethods', 'mapping.rb')))
        end

        def country_mapping
          @@country_mapping ||= data[:mapping]
        end

        def base
          @@base ||= data[:base]
        end

        def driver
          @@driver ||= SOAP::WSDLDriverFactory.new("http://www.xmethods.net/sd/2001/CurrencyExchangeService.wsdl").create_rpc_driver
        end

      end

      # Cached values for the XMethods exchange rate service.
      class CachedXMethods < ExchangeRate

        # This is the only method that a subclass of ExchangeRate
        # needs to implement. This is a good example to follow.
        def get_rate
          data[@curr]
        end

        private

        def data
          @@data ||= eval(File.read(File.join(Units::Config::CONFIGDIR, 'xmethods', 'cached.rb')))
        end

      end #class CachedXMethods
    end

  private

    #--
    # Trans: What is --base-currency-- all about?
    #++
    def conversions(unit)
      @conversions[unit] || (unit == '--base-currency--'.to_sym ? :none : nil)
    end

  end

  # Contains some configuration related constants
  module Config
    # The standard service used for looking up currency exchange rates
    DEFAULT_CURRENCY_SERVICE = Units::Converter::ExchangeRate::XMethods
  end

end
end
