module PkiExpress

  class TrustServiceAuthParameters
    attr_accessor :service_info, :auth_url

    def initialize(model)
      @service_info = nil
      @auth_url = nil

      unless model.nil?
        @auth_url = model.fetch(:authUrl)

        service_info = model.fetch(:serviceInfo)
        if service_info
          @service_info = TrustServiceInfo.new(service_info)
        end
      end
    end

  end
end