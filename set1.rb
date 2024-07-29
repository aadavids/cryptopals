module Set1

  module Base
    def self.hex_to_base64 hex
      [hex_to_bytes(hex)].pack("m")
    end

    def self.hex_to_bytes hex
      [hex].pack("H*").bytes
    end
  end

  class FixedXOR
    def initialize key
      @key = Set1::Base.hex_to_bytes key
      @key_hex = key
    end

    def convert hex
      if hex.length != key_hex.length
        throw ArgumentError "string and key must be equal length"
      end

      bytes = Set1::Base.hex_to_bytes(string)
      bytes.zip(@key).map {|a, b| a^b}.pack('C*').unpack('H*').first
    end
  end
end
