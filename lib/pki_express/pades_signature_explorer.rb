module PkiExpress
  class PadesSignatureExplorer < SignatureExplorer

    def initialize(config=PkiExpressConfig.new)
      super(config)
    end

    def open()
      if @signature_file_path.nil?
        raise 'The signature file was not set'
      end

      args = [@signature_file_path]

      # Verify and add common options
      verify_and_add_common_options(args)

      # This operation can only be used on versions greater
      # than 1.3 of the PKI Express.
      @version_manager.require_version('1.3')

      # Invoke command.
      result = invoke(Commands::OPEN_PADES, args)

      # Parse output and return model.
      model = parse_output(result)
      PadesSignature.new(model)
    end

  end
end