module PkiExpress
  class DigestAlgorithmAndValue
    attr_accessor :algorithm, :value
    def initialize(model)
      @algorithm = nil
      @value = nil

      unless model.nil?
        value = model.fetch(:value)
        algorithm = model.fetch(:algorithm)
        if value.nil?
          raise 'The value was not set'
        end
        if algorithm.nil?
          raise 'The algorithm was not set'
        end

        @value = Base64.decode64(value).bytes
        @algorithm = DigestAlgorithm.get_instance_by_api_model(algorithm)
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