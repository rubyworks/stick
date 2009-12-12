require 'binary/base'

converter 'binary_iec_base' do
  binary_iec_unit('bit',  :b){ 'binary_base:b' }
  binary_iec_unit('byte', :B){ '8.0 b' }
end
