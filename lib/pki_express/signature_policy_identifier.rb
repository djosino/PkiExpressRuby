module PkiExpress
  class SignaturePolicyIdentifier
    attr_accessor :digest, :oid, :uri

    def initialize(model)
      @digest = nil
      @oid = nil
      @uri = nil

      unless model.nil?
        digest = model.fetch(:digest)
        unless digest.nil?
          DigestAlgorithmAndValue.new(digest)
        end
        oid = model.fetch(:oid)
        uri = model.fetch(:uri)
      end
    end

  end
end