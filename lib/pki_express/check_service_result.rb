module PkiExpress

  class CheckServiceResult

    attr_accessor :user_has_certificates

    def initialize(model)
      @user_has_certificates = nil

      unless model.nil?
        @user_has_certificates = model.fetch(:userHasCertificates)
      end
    end

  end
end