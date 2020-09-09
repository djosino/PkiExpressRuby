module PkiExpress

  class DiscoverServicesResult

    attr_accessor :services, :auth_parameters

    def initialize(model)
      @services = []
      @auth_parameters = []

      unless model.nil?
        services = model.fetch(:services)
        if services
          @services = services.map { |s| TrustServiceInfo.new(s) }
        end

        auth_parameters = model.fetch(:authParameters)
        if auth_parameters
          @auth_parameters = auth_parameters.map { |a| TrustServiceAuthParameters.new(a) }
        end

      end
    end

  end
end