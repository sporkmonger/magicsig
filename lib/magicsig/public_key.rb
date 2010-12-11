require 'magicsig'
require 'openssl'

module MagicSig
  class PublicKey
    MAGIC_KEY_PATTERN = /^RSA\.([a-zA-Z0-9_-]+)\.([a-zA-Z0-9_-]+)$/

    def initialize(modulus, exponent)
      @modulus = modulus
      @exponent = exponent
    end

    attr_reader :modulus
    attr_reader :exponent

    def key_id=(new_key_id)
      @key_id = new_key_id
    end

    def key_id
      @key_id ||= MagicSig.base64url_encode(
        OpenSSL::Digest::SHA256.new(self.to_s).digest
      )
      return @key_id
    end

    def ==(other)
      return false unless other.kind_of?(MagicSig::PublicKey)
      return self.modulus == other.modulus && self.exponent == other.exponent
    end

    def to_s
      return (
        "RSA.#{MagicSig.i_to_base64url(modulus)}." +
        "#{MagicSig.i_to_base64url(exponent)}"
      )
    end

    def to_pem
      return self.to_openssl.to_pem
    end

    def to_der
      return self.to_openssl.to_der
    end

    def to_openssl
      @openssl_key ||= (begin
        key = OpenSSL::PKey::RSA.new
        key.n = self.modulus
        key.e = self.exponent
        key
      end)
      return @openssl_key
    end

    def self.parse_magic_key(data)
      modulus, exponent = data.match(MAGIC_KEY_PATTERN)[1..2]
      return MagicSig::PublicKey.new(
        MagicSig.base64url_to_i(modulus),
        MagicSig.base64url_to_i(exponent)
      )
    end

    def self.parse_pem(data)
      openssl_key = OpenSSL::PKey::RSA.new(data)
      return MagicSig::PublicKey.new(openssl_key.n, openssl_key.e)
    end
    class <<self
      alias_method :parse_der, :parse_pem
    end
  end
end
