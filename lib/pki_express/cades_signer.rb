# frozen_string_literal: true

module PkiExpress
  class CadesSigner < Signer
    attr_accessor :commitment_type, :encapsulated_content
    attr_accessor :overwrite_original_file, :output_file_path

    def initialize(config = PkiExpressConfig.new)
      super(config)
      @version_manager = VersionManager.new
      @encapsulated_content = true
      @commitment_type = false
      @overwrite_original_file = false
    end

    def pdf_to_sign_path=(path)
      raise 'The provided file to be signed was not found' unless File.exist?(path)

      @pdf_to_sign_path = path
    end

    def sign(get_cert = false)
      raise 'The file to be signed was not set' unless @pdf_to_sign_path
      if @overwrite_original_file == false && @output_file_path.nil?
        raise 'The output destination was not set'
      end

      args = [@pdf_to_sign_path]

      # Logic to overwrite original file or use the output file
      if @overwrite_original_file
        args.append('--overwrite')
      else
        args.append(@output_file_path)
      end

      # Verify and add common options between signers
      verify_and_add_common_options(args)

      unless @encapsulated_content
        args.append('--detached')
      end

      if @commitment_type
        args.append('--commitment-type', @commitment_type)
      end

      if get_cert
        # This operation can only be used on
        # version greater than 1.8 of the PKI Express.
        @version_manager.require_version('1.8')
        # Invoke command.
        result = invoke(Commands::SIGN_CADES, args)

        # Parse output and return model.
        model = JSON.parse(Base64.decode64(result[0]))
        PKCertificate.new(model['signer'])
      else
        # This operation can only be used on
        # version greater than 1.3 of the PKI Express.
        @version_manager.require_version('1.3')

        invoke_plain(Commands::SIGN_CADES, args)
      end
    end
  end
end
