module PkiExpress
  class PkiItalyCertificateTypes < Enum
    UNDEFINED = 'Undefined'
    CNS = 'Cns'
    DIGITAL_SIGNATURE = 'DigitalSignature'

    VALUES = [
        UNDEFINED, CNS, DIGITAL_SIGNATURE
    ]
  end
end
