module PkiExpress

  class SignatureStarter < BaseSigner

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @certificate_path = nil
    end

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
      unless File.exists?(path)
        raise 'The provided "certificate_path" does not exist'
      end

      @certificate_path = path
    end
    private :_set_certificate_path

    # endregion

    def self.get_result(response, transfer_file)
      return {
          toSignHash: response[0],
          digestAlgorithmName: response[1],
          digestAlgorithmOid: response[2],
          transferFile: transfer_file
      }
    end

    def start
      raise NotImplementedError.new('This method is not implemented')
    end
  end

end
