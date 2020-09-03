module PkiExpress

  class PadesSigner < Signer
    attr_accessor :suppress_default_visual_representation, :overwrite_original_file
    attr_accessor :custom_signature_field_name, :certification_level, :reason

    def initialize(config=PkiExpressConfig.new)
      super(config)
      @pdf_to_sign_path = nil
      @vr_json_path = nil
      @overwrite_original_file = false
      @version_manager = VersionManager.new
      @custom_signature_field_name = nil
      @certification_level = nil
      @reason = nil
      @suppress_default_visual_representation = false
    end

    # region set_visual_representation

    def visual_representation_content_raw
      _get_visual_representation_content_raw
    end

    def _get_visual_representation_content_raw
      unless @vr_json_path
        return nil
      end

      File.read(@vr_json_path)
    end
    private :_get_visual_representation_content_raw

    def visual_representation_content_raw=(content_raw)
      _set_visual_representation_content_raw(content_raw)
    end

    def _set_visual_representation_content_raw(content_raw)
      unless content_raw
        raise 'The provided "visual_representation" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @vr_json_path = temp_file_path
    end
    private :_set_visual_representation_content_raw

    def visual_representation_path
      _get_visual_representation_path
    end

    def _get_visual_representation_path
      @vr_json_path
    end
    private :_get_visual_representation_path

    def visual_representation_path=(path)
      _set_visual_representation_path(path)
    end

    def _set_visual_representation_path(path)
      unless path
        raise 'The provided "visual_representation_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "visual_representation_path" does not exist'
      end
      @vr_json_path = path
    end
    private :_set_visual_representation_path

    def visual_representation
      _get_visual_representation
    end

    def _get_visual_representation
      unless @vr_json_path
        return nil
      end

      content =  File.read(@vr_json_path)
      JSON.parse(content)
    end
    private :_get_visual_representation


    def visual_representation=(vr)
      _set_visual_representation(vr)
    end

    def _set_visual_representation(vr)
      temp_file_path = self.create_temp_file
      json = JSON.pretty_generate(vr.to_model)
      File.open(temp_file_path, 'w') do |f|
        f.write(json)
      end
      @vr_json_path = temp_file_path
    end
    private :_set_visual_representation

    # endregion

    # region The "pdf_to_sign" accessors

    def pdf_to_sign
      _get_pdf_to_sign
    end

    def _get_pdf_to_sign
      unless @pdf_to_sign_path
        return nil
      end

      File.read(@pdf_to_sign_path)
    end
    private :_get_pdf_to_sign

    def pdf_to_sign=(content_raw)
      _set_pdf_to_sign(content_raw)
    end

    def _set_pdf_to_sign(content_raw)
      unless content_raw
        raise 'The provided "pdf_to_sign" is not valid'
      end

      temp_file_path = self.create_temp_file
      File.open(temp_file_path, 'wb') do |f|
        f.write(content_raw)
      end
      @pdf_to_sign_path = temp_file_path
    end
    private :_set_pdf_to_sign

    def pdf_to_sign_base64
      _get_pdf_to_sign_base64
    end

    def _get_pdf_to_sign_base64
      unless @pdf_to_sign_path
        return nil
      end

      content = File.read(@pdf_to_sign_path)
      Base64.encode64(content)
    end
    private :_get_pdf_to_sign_base64

    def pdf_to_sign_base64=(content_base64)
      _set_pdf_to_sign_base64(content_base64)
    end

    def _set_pdf_to_sign_base64(content_base64)
      unless content_base64
        raise 'The provided "pdf_to_sign_base64" is not valid'
      end

      begin
        content_raw = Base64.decode64(content_base64)
      rescue Error
        raise 'The provided "pdf_to_sign_base64" is not Base64-encoded'
      end

      _set_pdf_to_sign(content_raw)
    end
    private :_set_pdf_to_sign_base64

    def pdf_to_sign_path
      _get_pdf_to_sign_path
    end

    def _get_pdf_to_sign_path
      @pdf_to_sign_path
    end
    private :_get_pdf_to_sign_path

    def pdf_to_sign_path=(path)
      _set_pdf_to_sign_path(path)
    end

    def _set_pdf_to_sign_path(path)
      unless path
        raise 'The provided "pdf_to_sign_path" is not valid'
      end
      unless File.exists?(path)
        raise 'The provided "pdf_to_sign_path" does not exist'
      end
      @pdf_to_sign_path = path
    end
    private :_set_pdf_to_sign_path

    # endregion

    def sign(get_cert=false)
      unless @pdf_to_sign_path
        raise 'The PDF to be signed was not set'
      end

      unless @overwrite_original_file || @output_file_path
        raise 'The output destination was not set'
      end

      args = [
        @pdf_to_sign_path,
      ]

      # Logic to overwrite original file or use the output file
      if @overwrite_original_file
        args.append('--overwrite')
      else
        args.append(@output_file_path)
      end

      # Verify and add common options between signers.
      verify_and_add_common_options(args)

      if @vr_json_path
        args.append('--visual-rep')
        args.append(@vr_json_path)
      end

      if @custom_signature_field_name
        args.append('--custom-signature-field-name')
        args.append(@custom_signature_field_name)
        # This option can only be used on versions greater than 1.15.0 of the
        # PKI Express.
        @version_manager.require_version('1.15')
      end

      if @certification_level
        args.append('--certification-level')
        args.append(@certification_level)
        # This option can only be used on versions greater than 1.16.0 of the
        # PKI Express.
        @version_manager.require_version('1.16')
      end

      if @suppress_default_visual_representation
        args.append('--suppress-default-visual-rep')
        # This option can only be used on versions greater than 1.13.1 of the
        # PKI Express.
        @version_manager.require_version('1.13.1')
      end

      if @reason
        args.append('--reason')
        args.append(@reason)
        # This option can only be used on versions greater than 1.13 of the
        # PKI Express.
        @version_manager.require_version('1.13')
      end

      if get_cert
        # This option can only be used on versions greater than 1.8.0 of the
        # PKI Express.
        @version_manager.require_version('1.8')

        # Invoke command.
        result = invoke(Commands::SIGN_PADES, args)

        # Parse output and return result.
        model = parse_output(result)
        return PKCertificate.new(model.fetch(:signer))
      else  
        # Invoke command with plain text output (to support PKI Express < 1.3)
        result = invoke_plain(Commands::SIGN_PADES, args)
      end

    end

  end
end