module PkiExpress
  class Authentication < PkiExpressOperator

    attr_accessor :use_external_storage

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @nonce_base64 = nil
      @certificate_path = nil
      @signature_base64 = nil
      @use_external_storage = false
    end

    # region The "nonce" accessors

    def nonce
      _get_nonce
    end

    def _get_nonce
      unless @nonce_base64
        return nil
      end

      Base64.decode64(@nonce_base64)
    end
    private :_get_nonce

    def nonce=(nonce)
      _set_nonce(nonce)
    end

    def _set_nonce(nonce)
      unless nonce
        raise 'The provided "nonce" is not valid'
      end

      begin
        b64 = Base64.encode64(nonce)
      rescue Error
        raise 'The provided "nonce" is not valid'
      end

      @nonce_base64 = b64
    end
    private :_set_nonce

    def nonce_base64
      _get_nonce_base64
    end

    def _get_nonce_base64
      @nonce_base64
    end
    private :_get_nonce_base64

    def nonce_base64=(nonce_base64)
      unless nonce_base64
        raise 'The provided "nonce_base64" is not valid'
      end

      begin
        Base64.decode64(nonce_base64)
      rescue Error
        raise 'The provided "nonce_base64" is not Base64-encoded'
      end

      @nonce_base64 = nonce_base64
    end

    #endregion

    # region The "certificate" accessors

    def certificate
      _get_certificate
    end

    def _get_certificate
      unless @certificate_path
        return nil
      end

      File.read(@certificate_path)
    end
    private :_get_certificate

    def certificate=(content_raw)
      _set_certificate(content_raw)
    end

    def _set_certificate(content_raw)
      unless content_raw
        raise 'The provided "certificate" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @certificate_path = temp_file_path
    end
    private :_set_certificate

    def certificate_base64
      _get_certificate_base64
    end

    def _get_certificate_base64
      unless @certificate_path
        return nil
      end

      content = File.read(@certificate_path)
      Base64.encode64(content)
    end
    private :_get_certificate_base64

    def certificate_base64=(content_base64)
      _set_certificate_base64(content_base64)
    end

    def _set_certificate_base64(content_base64)
      unless content_base64
        raise 'The provided "certificate_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "certificate_base64" is not Base64-encoded'
      end

      _set_certificate(content_raw)
    end
    private :_set_certificate_base64

    def certificate_path
      _get_certificate_path
    end

    def _get_certificate_path
      @certificate_path
    end
    private :_get_certificate_path

    def certificate_path=(path)
      _set_certificate_path(path)
    end

    def _set_certificate_path(path)
      unless path
        raise 'The provided "certificate_path" is not valid'
      end
      if File.exists?(path)
        raise 'The provided "certificate_path" does not exist'
      end

      @certificate_path = path
    end
    private :_set_certificate_path

    # endregion

    # region The "signature" accessors

    def signature
      _get_signature
    end

    def _get_signature
      unless @signature_base64
        return nil
      end

      Base64.decode64(@signature_base64)
    end
    private :_get_signature

    def signature=(signature)
      _set_signature(signature)
    end

    def _set_signature(signature)
      unless signature
        raise 'The provided "signature" is not valid'
      end
      begin
        b64 = Base64.encode64(signature)
      rescue Error
        raise 'The provided "signature" is not valid'
      end

      @signature_base64 = b64
    end
    private :_set_signature

    def signature_base64
      _get_signature_base64
    end

    def _get_signature_base64
      @signature_base64
    end
    private :_get_signature_base64

    def signature_base64=(signature_base64)
      _set_signature_base64(signature_base64)
    end

    def _set_signature_base64(signature_base64)
      unless signature_base64
        raise 'The provided "signature_base64" is not valid'
      end
      begin
        Base64.decode64(signature_base64)
      rescue Error
        raise 'The provided "signature_base64" is not Base64-encoded'
      end

      @signature_base64 = signature_base64
    end
    private :_set_signature_base64

    # endregion

    def start
      args = []

      # The option "use external storage" is used to ignore the PKI Express's
      # nonce verification, to make a own nonce store and nonce verification.
      if @use_external_storage
        args.append('--nonce-store')
        args.append(@config.transfer_data_folder)
      end

      # This operation can only be used on versions greater then 1.4 of PKI
      # Express.
      @version_manager.require_version('1.4')

      # Invoke command.
      result = invoke(Commands::START_AUTH, args)

      # Parse output and return result.
      model = parse_output(result)
      AuthStartResult.new(model)
    end

    def complete
      unless @nonce_base64
        raise 'The nonce was not set.'
      end
      unless @certificate_path
        raise 'The certificate file was not set.'
      end
      unless @signature_base64
        raise 'The signature was not set.'
      end

      args = [
        @nonce_base64,
        @certificate_path,
        @signature_base64
      ]

      # The option "use external storage" is used to ignore the PKI Express's
      # nonce verification, to make a own nonce store and nonce verification.
      unless @use_external_storage
        args.append('--nonce-store')
        args.append(@config.transfer_data_folder)
      end

      # This configuration can only be used on versions greater than 1.4 of PKI
      # Express.
      @version_manager.require_version('1.4')

      # Invoke command.
      result = invoke(Commands::COMPLETE_AUTH, args)

      # Parse output and return result.
      model = parse_output(result)
      AuthCompleteResult.new(model)
    end
  end
end