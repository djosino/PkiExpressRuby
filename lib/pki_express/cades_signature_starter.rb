module PkiExpress

  class CadesSignatureStarter < SignatureStarter

    attr_accessor :encapsulated_content

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @file_to_sign_path = nil
      @data_file_path = nil
      @encapsulated_content = nil
    end

    # region The "file_to_sign" accessors

    def file_to_sign
      _get_file_to_sign
    end

    def _get_file_to_sign
      unless @file_to_sign_path
        return nil
      end

      File.read(@file_to_sign_path)
    end
    private :_get_file_to_sign

    def file_to_sign=(content_raw)
      _set_file_to_sign(content_raw)
    end

    def _set_file_to_sign(content_raw)
      unless content_raw
        raise 'The provided "file_to_sign" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @file_to_sign_path = temp_file_path
    end
    private :_set_file_to_sign

    def file_to_sign_base64
      _get_file_to_sign_base64
    end

    def _get_file_to_sign_base64
      unless @file_to_sign_path
        return nil
      end

      content = File.read(@file_to_sign_path)
      Base64.encode64(content)
    end
    private :_get_file_to_sign_base64

    def file_to_sign_base64=(content_base64)
      _set_file_to_sign_base64(content_base64)
    end

    def _set_file_to_sign_base64(content_base64)
      unless content_base64
        raise 'The provided "file_to_sign_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "file_to_sign_base64" is not Base64-encoded'
      end

      _set_file_to_sign(content_raw)
    end
    private :_set_file_to_sign_base64

    def file_to_sign_path
      _get_file_to_sign_path
    end

    def _get_file_to_sign_path
      @file_to_sign_path
    end
    private :_get_file_to_sign_path

    def file_to_sign_path=(path)
      _set_file_to_sign_path(path)
    end

    def _set_file_to_sign_path(path)
      unless path
        raise 'The provided "file_to_sign_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "file_to_sign_path" does not exist'
      end

      @file_to_sign_path = path
    end
    private :_set_file_to_sign_path

    # endregion

    # region The "data_file" accessors

    def data_file
      _get_data_file
    end

    def _get_data_file
      unless @data_file_path
        return nil
      end

      File.read(@data_file_path)
    end
    private :_get_data_file

    def data_file=(content_raw)
      _set_data_file(content_raw)
    end

    def _set_data_file(content_raw)
      unless content_raw
        raise 'The provided "data_file" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @data_file_path = temp_file_path
    end
    private :_set_data_file

    def data_file_base64
      _get_data_file_base64
    end

    def _get_data_file_base64
      unless @data_file_path
        return nil
      end

      content = File.read(@data_file_path)
      Base64.encode64(content)
    end
    private :_get_data_file_base64

    def data_file_base64=(content_base64)
      _set_data_file_base64(content_base64)
    end

    def _set_data_file_base64(content_base64)
      unless content_base64
        raise 'The provided "data_file_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "data_file_base64" is not Base64-encoded'
      end

      _set_data_file(content_raw)
    end
    private :_set_data_file_base64

    def data_file_path
      _get_data_file_path
    end

    def _get_data_file_path
      @data_file_path
    end
    private :_get_data_file_path

    def data_file_path=(path)
      _set_data_file_path(path)
    end

    def _set_data_file_path(path)
      unless path
        raise 'The provided "data_file_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "data_file_path" does not exist'
      end

      @data_file_path = path
    end
    private :_set_data_file_path

    # endregion

    def start

      unless @file_to_sign_path
        raise 'The file to be signed was not set'
      end

      unless @certificate_path
        raise 'The certificate was not set'
      end

      # Generate transfer file.
      transfer_file_id = get_transfer_filename

      args = [
          @file_to_sign_path,
          @certificate_path,
          File.expand_path(transfer_file_id, @config.transfer_data_folder),
      ]

      # Verify and add common options between signers.
      verify_and_add_common_options(args)

      if @data_file_path
        args.append('--data-file')
        args.append(@data_file_path)
      end

      if @encapsulated_content
        args.append('--detached')
      end

      # This operation can only be used on version greater than 1.3 of the
      # PKI Express.
      @version_manager.require_version('1.3')

      # Invoke command.
      result = invoke(Commands::START_CADES, args)

      # Parse output and return model.
      model = parse_output(result)
      SignatureStartResult.new(model, transfer_file_id)
    end
  end

end
