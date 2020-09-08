module PkiExpress
  class TrustServicesManager < PkiExpressOperator
    def initialize(config=PkiExpressConfig.new)
      super(config)
    end

    def check_by_cpf(service, cpf)
      unless service
        raise "The provided service is not valid"
      end

      unless cpf
          raise "The provided CPF is not valid"
      end

      args = [
        service,
        '--cpf',
        cpf,
      ]

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::CHECK_SERVICE, args)

      # Parse output and return result.
      model = parse_output(response)
      CheckServiceResult.new(model)
    end

    def check_by_cnpj(service, cnpj)
      unless service
        raise "The provided service is not valid"
      end

      unless cnpj
          raise "The provided CNPJ is not valid"
      end

      args = [
        service,
        '--cnpj',
        cnpj,
      ]

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::CHECK_SERVICE, args)

      # Parse output and return result.
      model = parse_output(response)
      CheckServiceResult.new(model)
    end

    def discover_by_cpf(cpf, throw_exceptions=false)
      unless cpf
        raise "The provided CPF is not valid"
      end

      args = [
        '--cpf', 
        cpf
      ]

      if throw_exceptions
        args.append('--throw')
      end

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::DISCOVER_SERVICES, args)

      # Parse output and return result.
      model = parse_output(response)
      DiscoverServicesResult.new(model).services
    end

    def discover_by_cnpj(cnpj, throw_exceptions=false)
      unless cnpj
        raise "The provided CNPJ is not valid"
      end

      args = [
        '--cnpj', 
        cnpj
      ]

      if throw_exceptions
        args.append('--throw')
      end
      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::DISCOVER_SERVICES, args)

      # Parse output and return result.
      model = parse_output(response)
      DiscoverServicesResult.new(model).services
    end

    def discover_by_cpf_and_start_auth(cpf, redirect_url, 
      session_type=TrustServiceSessionTypes::SIGNATURE_SESSION, 
      custom_state=nil, throw_exceptions=false)
      unless cpf
          raise "The provided CPF is not valid"
      end
      unless redirect_url
          raise "The provided redirectUrl is not valid"
      end
      unless session_type
        raise "No session type was provided"
      end

      args = [
        '--cpf',
        cpf,
        '--redirect-url',
        redirect_url,
        '--session-type',
        session_type,
      ]

      if custom_state
          args.append('--custom-state')
          args.append(custom_state)
      end

      if throw_exceptions
          args.append('--throw')
      end

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::DISCOVER_SERVICES, args)

      # Parse output and return result.
      model = parse_output(response)
      DiscoverServicesResult.new(model).auth_parameters
    end

    def discover_by_cnpj_and_start_auth(cnpj, redirect_url, 
      session_type=TrustServiceSessionTypes::SIGNATURE_SESSION, 
      custom_state=nil, throw_exceptions=false)
      unless cnpj
        raise "The provided CNPJ is not valid"
      end
      unless redirect_url
          raise "The provided redirectUrl is not valid"
      end
      unless session_type
        raise "No session type was provided"
      end

      args = [
        '--cnpj',
        cnpj,
        '--redirect-url',
        redirect_url,
        '--session-type',
        session_type
      ]

      if custom_state
          args.append('--custom-state')
          args.append(custom_state)
      end

      if throw_exceptions
          args.append('--throw')
      end

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::DISCOVER_SERVICES, args)

      # Parse output and return result.
      model = parse_output(response)
      DiscoverServicesResult.new(model).auth_parameters
    end

    def password_authorize(service, username, password,
      session_type=TrustServiceSessionTypes::SIGNATURE_SESSION)
      unless service
        raise "The provided service is not valid"
      end

      unless username
        raise "The provided username is not valid"
      end

      unless password
          raise "The provided password is not valid"
      end

      unless session_type
          raise "No session type was provided"
      end

      args = [
        service,
        username,
        password,
        session_type
      ]

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::PASSWORD_AUTHORIZE, args)

      # Parse output and return result.
      model = parse_output(response)
      TrustServiceSessionResult.new(model)
    end

    def complete_auth(code, state)
      unless code
        raise "The provided code is not valid"
      end

      unless state
          raise "The provided state is not valid"
      end

      args = [code, state]

      # This operation can only be used on versions greater than 1.18 of
      # the PKI Express.
      @version_manager.require_version('1.18')

      # Invoke command.
      response = invoke(Commands::COMPLETE_SERVICE_AUTH, args)

      # Parse output and return result.
      model = parse_output(response)
      TrustServiceSessionResult.new(model)
    end

  end
end