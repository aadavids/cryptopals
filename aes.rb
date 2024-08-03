require 'openssl'
module AES
  def self.decrypt_ecb ciphertext, key
    cipher = OpenSSL::Cipher::AES128.new(:ECB)
    cipher.decrypt
    cipher.key = key
    cipher.update(ciphertext) + cipher.final
  end
end
