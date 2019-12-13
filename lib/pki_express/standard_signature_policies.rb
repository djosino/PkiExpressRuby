module PkiExpress

  class StandardSignaturePolicies
    PKI_BRAZIL_CADES_ADR_BASICA = 'adrb'
    PKI_BRAZIL_CADES_ADR_BASICA_WITH_REVOCATION_VALUE = 'adrb-rv'
    PKI_BRAZIL_CADES_ADR_TEMPO = 'adrt'
    PKI_BRAZIL_CADES_ADR_COMPLETA = 'adrc'
    CADES_BES = 'cades'
    CADES_BES_WITH_REVOCATION_VALUES = 'cades-rv'
    CADES_T = 'cades-t'

    PADES_BASIC = 'pades'
    PADES_BASIC_WITH_LTV = 'pades-ltv'
    PADES_T = 'pades-t'
    PKI_BRAZIL_PADES_ADR_BASICA = 'pades-ltv'
    PKI_BRAZIL_PADES_ADR_BASICA_WITH_LTV = 'adrb-ltv'
    PKI_BRAZIL_PADES_ADR_TEMPO = 'adrt'

    NFE_PADRAO_NACIONAL = 'nfe'
    XADES_BES = 'xades'
    XML_DSIG_BASIC = 'basic'
    PKI_BRAZIL_XML_ADR_BASIC = 'adrb'
    PKI_BRAZIL_XML_ADR_TEMPO = 'adrt'
    COD_WITH_SHA1 = 'cod-sha1'
    COD_WITH_SHA256 = 'cod-sha256'

    def self.require_timestamp(policy)
      if policy.nil?
        return false
      end

      return policy == PKI_BRAZIL_CADES_ADR_TEMPO || policy == PKI_BRAZIL_CADES_ADR_COMPLETA || policy == CADES_T || policy == PADES_T || policy == PKI_BRAZIL_PADES_ADR_TEMPO || policy == PKI_BRAZIL_XML_ADR_TEMPO
    end
  end

end