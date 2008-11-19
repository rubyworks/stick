module Stick
module Units

  class Loader

    class << self

      def handles(*types)
        handles = @handles ||= []
        unless types.empty?
          res = handles.push(*types)
          Converter.register_loader(self)
          res
        else
          handles
        end
      end

      def method_added(m)
        eval %{
          def self.#{m}(*a, &b)
            (@instance ||= new).#{m}(*a, &b)
          end
        }
        super
      end

    end

  end

  class Converter

    @required_configs = {}

    class << self

      def require(file)
        @required_configs[file] ||= begin
          load_config(file + ".rb", self)
          true
        end
      end

#       def load(file)
#         load_config(file, self)
#       end

      def register_loader(loader)
        loaders[loader] ||= loader
        loader.handles.each do |h|
          loader_hash[h] ||= begin
            eval %{
              module_eval do
                def #{h}(*a, &b)
                  self.class.send(:loader_hash)[#{h.inspect}].#{h}(self, *a, &b)
                end
              end
            }
            loader
          end
        end
        @loader_hash
      end

    private

      def loaders
        @loaders ||= {}
      end

      def loader_hash
        @loader_hash ||= {}
      end

      def load_config(file, context)
        data = File.read(File.join(Units::Config::CONFIGDIR, file)) rescue File.read(file)
        context.instance_eval { eval data, nil, file }
      end

    end

    def load(file)
      self.class.send(:load_config, file, self)
    end

  end

  class StandardLoader < Loader

    handles 'unit'

    def unit(converter, name, args)
      converter.send(:register_unit, name, args)
    end

  end

end
end