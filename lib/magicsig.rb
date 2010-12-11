# Copyright 2010 Google, Inc
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

require 'magicsig/version'
require 'magicsig/envelope'

module MagicSig
  def self.base64url_encode(data)
    return [data].pack('m0').tr('+/', '-_').gsub(/[\s=]/, '')
  end

  def self.base64url_decode(data)
    s = data.size
    return (data.tr('-_', '+/').ljust(4 + 4 * (s / 4), '=')).unpack('m0').first
  end

  def self.base64url_to_i(data)
    return self.base64url_decode(data).unpack('H*')[0].to_i(16)
  end

  def self.i_to_base64url(integer)
    # Can this be done more efficiently?
    hex_string = integer.to_s(16)
    return self.base64url_encode([
      hex_string.rjust(2 + 2 * (hex_string.size / 2), '0')
    ].pack('H*').gsub(/^\000*/, ''))
  end
end
