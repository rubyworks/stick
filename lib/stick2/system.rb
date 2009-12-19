require 'stick2/frame'
require 'stick2/type'

module Stick
module Units

  def self.systems
    @systems ||= {}
  end

  def self.system(name, *frame, &block)
    system = System.new(name, *frame, &block)
    systems[name.to_sym] = system
    (class << self ; self ; end).class_eval do
       define_method(name){ system }
    end
  end

  #def self.convert(from, goal, &block)
  #  if String == from
  #    system, type = *from.split(':')
  #    from = @systems[system.to_sym].types[type.to_sym]
  #  end
  #  from.conversion(goal, &block)
  #end

  #

  class System

    attr :name

    attr :types

    #
    def initialize(name, *frame) #:yield:
      @name  = name.to_sym
      @frame = Frame.new(*frame.flatten) unless frame.empty?
      @types = {}
      yield(self) if block_given?
    end

    #
    def frame
      @frame
    end

    #
    def type(name, type, symbol, options={})
      type = Type.new(self, name, symbol, type, options)
      [name, symbol, [options[:aliases].to_a]].flatten.each do |key|
        types[key.to_sym] = type
      end
    end

    #
    def method_missing(name, *args)
      case name.to_s
      when /\=$/
        name = name.to_s.chomp('=').to_sym
        type = types.key?(name) ? types[name] : super
        type.conversion(*args)
      else
        name = name.to_sym
        types.key?(name) ? types[name] : super
      end
    end

    def inspect
      #list = types.keys.join(', ')
      "#<System:#{name}>"
    end

    # Returns a module to be included into Numeric.

    def numeric_module
      mod = Module.new
      types.each do |key, type|
        mod.module_eval do
          [type.name, type.symbol, *type.aliases].each do |m|
            define_method(m) do
              Measure.new(self, Unit.new(type))
            end
          end
        end
      end
      mod
    end

    #

    def ==(other)
      case other
      when Symbol
        name == other
      else
        super
      end
    end

  end

end
end

