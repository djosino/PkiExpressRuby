module PkiExpress

  class TrustServiceInfo

    attr_accessor :service, :provider, :badge_url

    def initialize(model)
      @service = nil
      @provider = nil
      @badge_url = nil

      unless model.nil?
        @provider = model.fetch(:provider)
        @badge_url = model.fetch(:badgeUrl)

        service = model.fetch(:service)
        if service
          @service = TrustServiceName.new(service)
        end
      end
    end

  end

  class TrustServiceName

    attr_accessor :name

    def initialize(model)
      @name = nil

      unless model.nil?
        @name = model.fetch(:name)
      end
    end

  end
end