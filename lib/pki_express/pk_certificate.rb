module PkiExpress

  class PKCertificate

    attr_accessor :subject_name, :email_address, :issuer_name, :serial_number,
                  :validity_start, :validity_end, :pki_brazil, :pki_italy,
                  :issuer, :binary_thumbprint_sha256, :thumbprint

    def initialize(model)
      @subject_name = nil
      @email_address = nil
      @issuer_name = nil
      @serial_number = nil
      @validity_start = nil
      @validity_end = nil
      @pki_brazil = nil
      @pki_italy = nil
      @issuer = nil
      @binary_thumbprint_sha256 = nil
      @thumbprint = nil

      unless model.nil?
        @email_address = model.fetch(:emailAddress)
        @serial_number = model.fetch(:serialNumber)
        @validity_start = model.fetch(:validityStart)
        @validity_end = model.fetch(:validityEnd)
        @thumbprint = model.fetch(:thumbprint)

        subject_name = model.fetch(:subjectName)
        if subject_name
          @subject_name = Name.new(subject_name)
        end

        issuer_name = model.fetch(:issuerName)
        if issuer_name
          @issuer_name = Name.new(issuer_name)
        end

        pki_brazil = model.fetch(:pkiBrazil)
        if pki_brazil
          @pki_brazil = PkiBrazilCertificateFields.new(pki_brazil)
        end

        pki_italy = model.fetch(:pkiItaly)
        if pki_italy
          @pki_italy = PkiItalyCertificateFields.new(pki_italy)
        end

        issuer = model.fetch(:issuer)
        if issuer
          @issuer = PKCertificate.new(issuer)
        end

        binary_thumbprint_sha256 = model.fetch(:binaryThumbprintSHA256)
        if binary_thumbprint_sha256
          @binary_thumbprint_sha256 = Base64.decode64(binary_thumbprint_sha256)
        end
      end
    end
  end

end