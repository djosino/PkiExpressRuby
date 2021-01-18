module PkiExpress
  class CadesSignature
    attr_accessor :encapsulated_content_type, :has_encapsulated_content, :signers

    def initialize(model)
      @encapsulated_content_type = nil
      @has_encapsulated_content = nil
      @signers = []

      unless model.nil?
        @encapsulated_content_type = model.fetch(:encapsulatedContentType)
        @has_encapsulated_content = model.fetch(:hasEncapsulatedContent)

        signers = model.fetch(:signers)
        if signers
          @signers = signers.map { |s| CadesSignerInfo.new(s) }
        end
      end
    end
  end


  class CadesTimestamp < CadesSignature
    attr_accessor :gen_time, :serial_number, :message_imprint

    def initialize(model)
      super(model)
      @gen_time = nil
      @serial_number = nil
      @message_imprint = nil
      @gen_time = model.fetch(:genTime)
      @serial_number = model.fetch(:serialNumber)
      @message_imprint = model.fetch(:messageImprint)
    end
  end


  class CadesSignerInfo
    attr_accessor :signing_time, :certified_date_reference, :message_digest
    attr_accessor :signature, :certificate, :signature_policy, :timestamps
    attr_accessor :validation_results

    def initialize(model)
      @signing_time = nil
      @certified_date_reference = nil
      @message_digest = nil
      @signature = nil
      @certificate = nil
      @signature_policy = nil
      @timestamps = []
      @validation_results = nil

      unless model.nil?
        @certified_date_reference = model.fetch(:certifiedDateReference)
        @signing_time =  model.fetch(:signingTime)

        message_digest =  model.fetch(:messageDigest)
        if message_digest
          @message_digest = DigestAlgorithmAndValue.new(message_digest)
        end

        signature =  model.fetch(:signature)
        if signature
          @signature = SignatureAlgorithmAndValue.new(signature)
        end

        certificate =  model.fetch(:certificate)
        if certificate
          @certificate = PKCertificate.new(certificate)
        end

        signature_policy =  model.fetch(:signaturePolicy)
        if signature_policy
          @signature_policy = SignaturePolicyIdentifier.new(signature_policy)
        end

        timestamps =  model.fetch(:timestamps)
        if timestamps
          @timestamps = timestamps.map { |t| CadesTimestamp.new(t) }
        end

        validation_results =  model.fetch(:validationResults)
        if validation_results
            @validation_results = ValidationResults.new(validation_results)
        end
      end
    end
  end
end
