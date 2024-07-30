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

  # this class operates on raw bytes. TODO: update others to match
  module SingleByteXOR
    CHAR_FREQUENCIES = {
      'e' => 11.1607,
      'a' => 8.4966,
      'r' => 7.5809,
      'i' => 7.5448,
      'o' => 7.1635,
      't' => 6.9509,
      'n' => 6.6544,
      's' => 5.7351,
      'l' => 5.4893,
      'c' => 4.5388,
      'u' => 3.6308,
      'd' => 3.3844,
      'p' => 3.1671,
      'm' => 3.0129
    }
    def self.encode bytes, key
      bytes.map {|a| a^key}
    end

    # assumes the message is english plaintext
    def self.break hex
      bytes = Base::hex_to_bytes(hex)

      keys = [*'a'..'z', *'A'..'Z', *'0'..'9']

      key = ''
      max_score = 0
      keys.each do |key_candidate|
        decoded = self.encode(bytes, key_candidate.bytes.first)
        score = self.score(decoded.pack("C*"))
         if score>max_score
          max_score = score
          key = key_candidate
         end
      end

      [key, self.encode(bytes, key.bytes.first).pack("C*")]
    end

    def self.score string
      string.each_char.reduce(0) do |acc, char|
        acc += CHAR_FREQUENCIES.fetch(char.downcase, 0)
      end
    end
  end
end
