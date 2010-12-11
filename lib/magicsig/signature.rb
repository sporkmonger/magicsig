module MagicSig
  class Signature
    def value
      @value ||= nil
    end

    def value=(new_value)
      @value = new_value
    end

    def key_id
      @key_id ||= nil
    end

    def key_id=(new_key_id)
      @key_id = new_key_id
    end

    def parse_json(data)
      require 'json'
      if data.respond_to?(:to_str)
        data = JSON.parse(data.to_str)
      elsif !data.kind_of?(Hash)
        raise TypeError, "Expected Hash or String, got #{data.class}."
      end
      self.value = data['value']
      self.key_id = data['key_id']
      return self
    end

    def self.parse_json(data)
      require 'json'
      if data.respond_to?(:to_str)
        data = JSON.parse(data.to_str)
      elsif !data.kind_of?(Hash)
        raise TypeError, "Expected Hash or String, got #{data.class}."
      end
      return Signature.new.parse_json(data)
    end

    def self.parse_xml(data)
      # TODO
    end
  end
end
