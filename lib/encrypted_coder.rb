# With this code, it's possible to search for a user account with encrypted CPF
# Fonts:
# 1 - Based on https://scotch.io/@jiggs/how-to-encrypt-data-without-gem-in-rails
# 2 - https://ruby-doc.org/core-2.3.0/Marshal.html
class EncryptedCoder
  include Crypt

  def load(value)
    return unless value.present?
    Marshal.load(Crypt.decrypt(Base64.decode64(value)))
  end

  def dump(value)
    Base64.encode64(Crypt.encrypt(Marshal.dump(value)))
  end
end
