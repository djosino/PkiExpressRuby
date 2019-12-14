module PkiExpress

  class StandardSignaturePolicies < Enum
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

    VALUES = [
        PKI_BRAZIL_CADES_ADR_BASICA,
        PKI_BRAZIL_CADES_ADR_BASICA_WITH_REVOCATION_VALUE,
        PKI_BRAZIL_CADES_ADR_TEMPO,
        PKI_BRAZIL_CADES_ADR_COMPLETA,
        CADES_BES,
        CADES_BES_WITH_REVOCATION_VALUES,
        CADES_T,
        PADES_BASIC,
        PADES_BASIC_WITH_LTV,
        PADES_T,
        PKI_BRAZIL_PADES_ADR_BASICA,
        PKI_BRAZIL_PADES_ADR_BASICA_WITH_LTV,
        PKI_BRAZIL_PADES_ADR_TEMPO,
        NFE_PADRAO_NACIONAL,
        XADES_BES,
        XML_DSIG_BASIC,
        PKI_BRAZIL_XML_ADR_BASIC,
        PKI_BRAZIL_XML_ADR_TEMPO,
        COD_WITH_SHA1,
        COD_WITH_SHA256
    ]

    def self.require_timestamp(policy)
      if policy.nil?
        return false
      end

      return policy == PKI_BRAZIL_CADES_ADR_TEMPO || policy == PKI_BRAZIL_CADES_ADR_COMPLETA || policy == CADES_T || policy == PADES_T || policy == PKI_BRAZIL_PADES_ADR_TEMPO || policy == PKI_BRAZIL_XML_ADR_TEMPO
    end
  end

end