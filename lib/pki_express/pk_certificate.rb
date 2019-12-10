module PkiExpress

  class PKCertificate

    attr_accessor :pki_italy, :email_address, :serial_number, :issuer_name,
                  :validity_start, :subject_name, :binary_thumbprint_sha256,
                  :validity_end, :thumbprint, :pki_brazil, :issuer

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

      unless model.nil?
        @email_address = model.fetch(:emailAddress)
        @serial_number = model.fetch(:serialNumber)
        @thumbprint = model.fetch(:thumbprint)
        @validity_start = model.fetch(:validityStart)
        @validity_end = model.fetch(:validityEnd)

        subject_name = model.fetch(:subjectName)
        unless subject_name.nil?
          @subject_name = Name.new(subject_name)
        end

        issuer_name = model.fetch(:issuerName)
        unless issuer_name.nil?
          @issuer_name = Name.new(issuer_name)
        end

        pki_brazil = model.fetch(:pkiBrazil)
        unless pki_brazil.nil?
          @pki_brazil = PkiBrazilCertificateFields.new(pki_brazil)
        end

        pki_italy = model.fetch(:pkiItaly)
        unless pki_italy.nil?
          @pki_italy = PkiItalyCertificateFields.new(pki_italy)
        end

        issuer = model.fetch(:issuer)
        unless issuer.nil?
          @issuer = PKCertificate.new(issuer)
        end

        binary_thumbprint_sha256 = model.fetch(:binaryThumbprintSHA256)
        unless binary_thumbprint_sha256.nil?
          @binary_thumbprint_sha256 = Base64.decode64(binary_thumbprint_sha256)
        end
      end
    end
  end

end