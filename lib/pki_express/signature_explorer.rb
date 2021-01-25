module PkiExpress
  class SignatureExplorer < PkiExpressOperator
    attr_accessor :validate

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @signature_file_path = nil
      @validate = nil
    end

    # region The "signature_file" accessors

    def signature_file=(content_raw)
      _set_signature_file(content_raw)
    end

    def _set_signature_file(content_raw)
      unless content_raw
        raise 'The provided "signature_file" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @signature_file_path = temp_file_path
    end
    private :_set_signature_file

    def signature_file_base64=(content_base64)
      _set_signature_file_base64(content_base64)
    end

    def _set_signature_file_base64(content_base64)
      unless content_base64
        raise 'The provided "signature_file_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "signature_file_base64" is not Base64-encoded'
      end

      _set_signature_file(content_raw)
    end
    private :_set_signature_file_base64

    def signature_file_path=(path)
      _set_signature_file_path(path)
    end

    def _set_signature_file_path(path)
      unless path
        raise 'The provided "signature_file_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "signature_file_path" does not exist'
      end
      @signature_file_path = path
    end
    private :_set_signature_file_path

    # endregion

    def verify_and_add_common_options(args)
      if @validate
        args << '--validate'
        # This operation can only be on versions greater
        # than 1.3 of the PKI Express.
        @version_manager.require_version('1.3')
      end
    end
  end
end