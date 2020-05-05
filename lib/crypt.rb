module Crypt
  class << self
    def encrypt(value)
      crypt(:encrypt, value)
    end

    def decrypt(value)
      crypt(:decrypt, value)
    end

    def crypt(cipher_method, value)
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      cipher.send(cipher_method)
      cipher.pkcs5_keyivgen(ENV['ENCRYPTION_KEY'])
      result = cipher.update(value)
      result << cipher.final
    end
  end
end
