module PkiExpress
  class TimestampAuthority
    attr_reader :url, :token, :ssl_thumbprint, :basic_auth, :auth_type

    def initialize(url)
      @url = url
      @auth_type = :none
      @token = nil
      @ssl_thumbprint = nil
      @basic_auth = nil
    end

    def set_oauth_token_authentication(token)
      @token = token
      @auth_type = :oauth_token
    end

    def set_basic_authentication(username, password)
      @basic_auth = "#{username}:#{password}"
      @auth_type = :basic_auth
    end

    def set_ssl_thumbprint(ssl_thumbprint)
      @ssl_thumbprint = ssl_thumbprint
      @auth_type = :ssl
    end

    def get_cmd_arguments
      args = []
      args.append('--tsa-url')
      args.append(url)

      case auth_type
      when :none
      when :basic_auth
        args.append('--tsa-basic-auth')
        args.append(@basic_auth)
      when :ssl
        args.append('--tsa-ssl-thumbprint')
        args.append(@ssl_thumbprint)
      when :oauth_token
        args.append('--tsa-token')
        args.append(token)
      else
        raise 'Unknown authentication type of the timestamp authority'
      end

      args
    end
  end
end