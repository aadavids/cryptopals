require 'openssl'
module AES
  BLOCK_SIZE = 16
  def self.decrypt_ecb ciphertext, key
    cipher = OpenSSL::Cipher::AES128.new(:ECB)
    cipher.decrypt
    cipher.key = key
    cipher.update(ciphertext) + cipher.final
  end

  # assume file of newline delimited hex encoded strings
  def self.detect_aes_ecb filename
    file =File.read filename
    ciphertexts = file.split("\n").map {|hex| [hex].pack("H*")}
    ciphertexts.max_by do |ct|
      ct.scan(/.{1,#{BLOCK_SIZE}}/).tally.values.max
    end
  end
end
