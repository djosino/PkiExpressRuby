module PkiExpress

  class BaseSigner < PkiExpressOperator

    def initialize(config=PkiExpressConfig.new)
      super(config)
    end

    protected
    def verify_and_add_common_options(args)

      if StandardSignaturePolicies::require_timestamp(@signature_policy) and
          @timestamp_authority.nil?
        raise 'The provided policy requires a timestamp authority and none was provided.'
      end

      # Set the signature policy.
      unless @signature_policy.nil?
        args << '--policy'
        args << @signature_policy

        # This operation evolved after version 1.5 to other signature policies.
        if @signature_policy != StandardSignaturePolicies::XML_DSIG_BASIC and @signature_policy != StandardSignaturePolicies::NFE_PADRAO_NACIONAL
          # This operation evolved after version 1.5 to other signature
          # policies.
          @version_manager.require_version('1.5')
        end

        if @signature_policy == StandardSignaturePolicies::COD_WITH_SHA1 or @signature_policy == StandardSignaturePolicies::COD_WITH_SHA256
          # These policies can only be used on version greater than 1.6 of
          # PKI Express.
          @version_manager.require_version('1.6')
        end

        if @signature_policy == StandardSignaturePolicies::PKI_BRAZIL_PADES_ADR_BASICA or @signature_policy == StandardSignaturePolicies::PKI_BRAZIL_PADES_ADR_BASICA_WITH_LTV or @signature_policy == StandardSignaturePolicies::PKI_BRAZIL_PADES_ADR_TEMPO
          # These policies can only be used on version greater than 1.12 of
          # PKI Express.
          @version_manager.require_version('1.12')
        end
      end

      # Add timestamp authority.
      if @timestamp_authority
        tsp_args = @timestamp_authority.get_cmd_arguments
        args.append(*tsp_args)


        # This option can only be used on version greater than 1.5 of the
        # PKI Express.
        @version_manager.require_version('1.5')
      end
    end
  end

end