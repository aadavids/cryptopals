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
    def self.encode bytes, key
      bytes.map {|a| a^key}
    end

    # assumes the message is english plaintext
    def self.break bytes
      keys = 0..255

      key = ''
      max_score = 0
      keys.each do |key_candidate|
        decoded = self.encode(bytes, key_candidate)
        score = English.score(decoded.pack("C*"))
         if score>max_score
          max_score = score
          key = key_candidate
         end
      end

      {key: key, key_str: [key].pack("C*"), confidence: max_score, string: self.encode(bytes, key).pack("C*")}
    end

    # detects a string encrypted by single character xor
    def self.detect hex_strings
      hex_strings.map { |string| Set1::SingleByteXOR.break(Base::hex_to_bytes(string))}.max_by { |result| result[:confidence] }
    end
  end

  module RepeatingKeyXOR
    def self.encrypt(string, key)
      key_stream = key * (string.length / key.length + 1)
      string.bytes.zip(key_stream.bytes).map {|a, b| a^b}.pack('C*')
    end

    def self.code(bytes, key)
      key_stream = key * (bytes.length / key.length + 1)
      bytes.zip(key_stream).map {|a, b| a^b}
    end

    # currently assumes string is longer than 200 characters
    def self.break(bytes)

      key_size_candidates = (2..40).sort_by do |size|
        [
          English.hamming_distance_bytes(bytes[0, size], bytes[size, size])/size.to_f,
          English.hamming_distance_bytes(bytes[size, size], bytes[size*2, size])/size.to_f,
          English.hamming_distance_bytes(bytes[size*2, size], bytes[size*3, size])/size.to_f,
          English.hamming_distance_bytes(bytes[size*3, size], bytes[size*4, size])/size.to_f,
      ].sum / 4
      end[0,3]

      max_score = 0
      key = ""
      plaintext = ""
      key_size_candidates.each do |key_size|
        chunks = bytes.each_slice(key_size).to_a
        size = chunks.map(&:length).max
        blocks = Array.new(size) { |i| chunks.map { |e| e[i] }.reject(&:nil?) }

        candidate_key = blocks.map {|block| SingleByteXOR.break(block)[:key]}

        candidate_plaintext = RepeatingKeyXOR.code(bytes, candidate_key).pack('C*')
        score = English.score(candidate_plaintext)
        if score > max_score
          max_score = score
          key = candidate_key
          plaintext = candidate_plaintext
        end
      end

      {key: key.pack('C*'), plaintext: plaintext}
    end
  end

  module English
    ENGLISH_HISTOGRAM = {
      "a"=>0.0651738,
      "b"=>0.0124248,
      "c"=>0.0217339,
      "d"=>0.0349835,
      "e"=>0.1041442,
      "f"=>0.0197881,
      "g"=>0.0158610,
      "h"=>0.0492888,
      "i"=>0.0558094,
      "j"=>0.0009033,
      "k"=>0.0050529,
      "l"=>0.0331490,
      "m"=>0.0202124,
      "n"=>0.0564513,
      "o"=>0.0596302,
      "p"=>0.0137645,
      "q"=>0.0008606,
      "r"=>0.0497563,
      "s"=>0.0515760,
      "t"=>0.0729357,
      "u"=>0.0225134,
      "v"=>0.0082903,
      "w"=>0.0171272,
      "x"=>0.0013692,
      "y"=>0.0145984,
      "z"=>0.0007836,
      " "=>0.1918182,
      '.'=>0.07 # approx for all other digits and puncuation
    }

    def self.score string
      return 0 unless self.printable?(string)
      input = string.downcase.tr('^ a-z', '.')
      histogram = self.frequencies(input)

      score = 1 / self.chi_squared(ENGLISH_HISTOGRAM, histogram)
      score *= 2 if histogram['.'] < 0.05
      score
    end

    def self.chi_squared(hist1, hist2)
      score = 0
      hist1.each do |k, v1|
        v2 = hist2[k] || 0
        next if v1.zero?
        score += (v1 - v2)**2 / v1
      end
      score
    end

    def self.printable?(string)
      string[/^[[:print:]]*$/]
    end

    def self.frequencies string
      result = Hash.new {|h,k| h[k] = 0}
      total = string.length
      string.each_char {|char| result[char] += 1}
      result.each { |k, v| result[k] = v.to_f / total }
      result
    end

    def self.hamming_distance s1, s2
      return ArgumentError "Strings must be equal length" unless s1.length == s2.length

      self.hamming_distance_bytes s1.bytes, s2.bytes
    end

    def self.hamming_distance_bytes b1, b2
      return ArgumentError "byte streams must be equal length" unless b1.length == b2.length

      b1.zip(b2).reduce(0) do |acc, (c1, c2)|
        acc + (c1 ^ c2).to_s(2).count("1")
      end
    end
  end
end
