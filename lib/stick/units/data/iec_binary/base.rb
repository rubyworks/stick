require 'binary/base'

converter 'binary_iec_base' do
  binary_iec_unit 'bit',  :abbrev => 'b', :alias => 'bits',  :equals => 'binary_base:b'
  binary_iec_unit 'byte', :abbrev => 'B', :alias => 'bytes', :equals => '8.0 b'
end
