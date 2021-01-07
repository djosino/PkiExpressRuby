module PkiExpress

  class SignatureAlgorithmAndValue
    attr_accessor :algorithm, :value
    def initialize(model)
      @algorithm = nil
      @value = nil
      algorithm_identifier = nil

      unless model.nil?
        value = model.fetch(:value)
        if value.nil?
          raise 'The value was not set'
        end
        @value = Base64.decode64(value).bytes
        
        algorithm_identifier = model.fetch(:algorithmIdentifier)
        unless algorithm_identifier.nil?
          algorithm = model.fetch(:algorithm)
          unless algorithm.nil?
            @algorithm = DigestAlgorithm.get_instance_by_api_model(algorithm)
          end
        end
      end
    end

    def hex_value
      @value.map { |b| b.to_s(16).rjust(2,'0') }.join.upcase
    end

    def hex_value=(value)
      @value = [value].pack('H*').unpack('C*')
    end
  end
end