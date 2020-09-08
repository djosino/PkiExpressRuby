require 'date'

module PkiExpress

  class TrustServiceSessionResult

    attr_accessor :session, :custom_state, :service, :session_type, :expires_on

    def initialize(model)
      @session = nil
      @custom_state = nil
      @service = nil
      @session_type = nil
      @expires_on = nil
      
      unless model.nil?
        @session = model.fetch(:session)
        @custom_state = model.fetch(:customState)
        @service = model.fetch(:service)
        @session_type = model.fetch(:type)

        expires_on = model.fetch(:expiresOn)
        if expires_on
          @expires_on = DateTime.iso8601(expires_on)
        end
      end
    end

  end
end