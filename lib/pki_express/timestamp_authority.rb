module PkiExpress
  class TimestampAuthority
    attr_reader :url, :token, :ssl_thumbprint, :basic_auth, :auth_type

    def initialize(url)
      @url = url
      @auth_type = TsaAuthenticationType::NONE
      @token = nil
      @ssl_thumbprint = nil
      @basic_auth = nil
    end

    def set_oauth_token_authentication(token)
      @token = token
      @auth_type = TsaAuthenticationType::OAUTH_TOKEN
    end

    def set_basic_authentication(username, password)
      @basic_auth = "#{username}:#{password}"
      @auth_type = TsaAuthenticationType::BASIC_AUTH
    end

    def set_ssl_thumbprint(ssl_thumbprint)
      @ssl_thumbprint = ssl_thumbprint
      @auth_type = TsaAuthenticationType::SSL
    end

    def get_cmd_arguments
      args = []
      args.append('--tsa-url')
      args.append(url)

      case auth_type
      when TsaAuthenticationType::NONE
      when TsaAuthenticationType::BASIC_AUTH
        args.append('--tsa-basic-auth')
        args.append(@basic_auth)
      when TsaAuthenticationType::SSL
        args.append('--tsa-ssl-thumbprint')
        args.append(@ssl_thumbprint)
      when TsaAuthenticationType::OAUTH_TOKEN
        args.append('--tsa-token')
        args.append(token)
      else
        raise 'Unknown authentication type of the timestamp authority'
      end

      args
    end
  end
end