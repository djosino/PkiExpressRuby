module PkiExpress

  class Signer < BaseSigner

    attr_accessor :output_file_path, :cert_thumb, :cert_password

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @output_file_path = nil
      @pkcs12_path = nil
      @cert_thumb = nil
      @cert_password = nil
      @use_machine = false
    end

    # region The "pkcs12" accessors

    def pkcs12
      _get_pkcs12
    end

    def _get_pkcs12
      unless @pkcs12_path
        return nil
      end

      File.read(@pkcs12_path)
    end
    private :_get_pkcs12

    def pkcs12=(content_raw)
      _set_pkcs12(content_raw)
    end

    def _set_pkcs12(content_raw)
      unless content_raw
        raise 'The provided "pkcs12" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @pkcs12_path = temp_file_path
    end
    private :_set_pkcs12

    def pkcs12_base64
      _get_pkcs12_base64
    end

    def _get_pkcs12_base64
      unless @pkcs12_path
        return nil
      end

      content = File.read(@pkcs12_path)
      Base64.encode64(content)
    end
    private :_get_pkcs12_base64

    def pkcs12_base64=(content_base64)
      _set_pkcs12_base64(content_base64)
    end

    def _set_pkcs12_base64(content_base64)
      unless content_base64
        raise 'The provided "content_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "content_base64" is not Base64-encoded'
      end

      _set_pkcs12(content_raw)
    end
    private :_set_pkcs12_base64

    def pkcs12_path
      _get_pkcs12_path
    end

    def _get_pkcs12_path
      @pkcs12_path
    end
    private :_get_pkcs12_path

    def pkcs12_path=(path)
      _set_pkcs12_path(path)
    end

    def _set_pkcs12_path(path)
      unless path
        raise 'The provided "content_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "content_path" does not exist'
      end

      @pkcs12_path = path
    end
    private :_set_pkcs12_path

    # endregion

    def verify_and_add_common_options(args)
      # Verify and add common option between signers and signature starters.
      super(args)

      if !@cert_thumb && !@pkcs12_path
        raise 'No PKCS #12 file or certificate\'s thumbprint was provided'
      end

      if @cert_thumb
        args.append('--thumbprint')
        args.append(@cert_thumb)
        @version_manager.require_version('1.3')
      end

      if @pkcs12_path
        args.append('--pkcs12')
        args.append(@pkcs12_path)
        @version_manager.require_version('1.3')
      end

      if @cert_password
        args.append('--password')
        args.append(@cert_password)
        @version_manager.require_version('1.3')
      end

      if @use_machine
        args.append('--machine')
        @version_manager.require_version('1.3')
      end
    end
    protected :verify_and_add_common_options
  end

end
