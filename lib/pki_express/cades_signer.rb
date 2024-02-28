# frozen_string_literal: true

require_relative 'commands'

module PkiExpress
  class CadesSigner < Signer
    attr_accessor :commitment_type, :encapsulated_content

    def initialize(config = PkiExpressConfig.new)
      super(config)
      @file_to_sign_path = nil
      @encapsulated_content = true
      @commitment_type = nil
    end

    def set_file_to_sign_from_path(path)
      raise 'The provided file to be signed was not found' unless File.exist?(path)

      @file_to_sign_path = path
    end

    def sign(get_cert = false)
      raise 'The file to be signed was not set' unless @file_to_sign_path
      raise 'The output destination was not set' unless @output_file_path

      args = [@file_to_sign_path]

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

      puts ([Commands::SIGN_PADES] + args).join(' ')

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
        @version_manager.require_version('1.3')
        # This operation can only be used on
        # version greater than 1.3 of the PKI Express.
        invoke_plain(Commands::SIGN_CADES, args)
      end
    end
  end
end
