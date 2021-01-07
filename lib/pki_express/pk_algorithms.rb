module PkiExpress
  class SignatureAlgorithms < Enum
    MD5_WITH_RSA = 'MD5WithRSA'
    SHA1_WITH_RSA = 'SHA1WithRSA'
    SHA256_WITH_RSA = 'SHA256WithRSA'
    SHA384_WITH_RSA = 'SHA384WithRSA'
    SHA512_WITH_RSA = 'SHA512WithRSA'
  end

  class PKAlgorithms < Enum
    RSA = 'RSA'
  end

  class SignatureAlgorithm
    attr_accessor :name, :oid, :xml_uri, :digest_algorithm, :pk_algorithm

    def initialize(name, oid, xml_uri, digest_algorithm, pk_algorithm)
      @name = name
      @oid = oid
      @xml_uri = xml_uri
      @digest_algorithm = digest_algorithm
      @pk_algorithm = pk_algorithm
    end

    def md5_with_rsa
      unless @md5_with_rsa
        @md5_with_rsa = RSASignatureAlgorithm.new(DigestAlgorithm.md5)
      end
    end

    def sha1_with_rsa
      unless @sha1_with_rsa
        @sha1_with_rsa = RSASignatureAlgorithm.new(DigestAlgorithm.sha1)
      end
    end

    def sha256_with_rsa
      unless @sha256_with_rsa
        @sha256_with_rsa = RSASignatureAlgorithm.new(DigestAlgorithm.sha256)
      end
    end

    def sha384_with_rsa
      unless @sha384_with_rsa
        @sha384_with_rsa = RSASignatureAlgorithm.new(DigestAlgorithm.sha384)
      end
    end

    def sha512_with_rsa
      unless @sha512_with_rsa
        @sha512_with_rsa = RSASignatureAlgorithm.new(DigestAlgorithm.sha512)
      end
    end

    def self.algorithms
      return [md5_with_rsa, sha1_with_rsa, sha256_with_rsa, sha384_with_rsa, sha512_with_rsa]
      end
    end

    def self.safe_algorithms
      return [sha1_with_rsa, sha256_with_rsa, sha384_with_rsa, sha512_with_rsa]
      end
    end
    private_class_method :algorithms, :safe_algorithms :new

    class << SignatureAlgorithm
      def get_instance_by_name(name)
        algorithms
        unless @algorithms.select{|v| v.name == name}.empty?
          return @algorithms.select{|v| v.name == name}.first
        end
        raise 'Unrecognized signature algorithm name: ' + name
      end

      def get_instance_by_oid(oid)
        algorithms
        unless @algorithms.select{|v| v.oid == oid}.empty?
          return @algorithms.select{|v| v.oid == oid}.first
        end
        raise 'Unrecognized signature algorithm oid: ' + oid
      end

      def get_instance_by_xml_uri(xml_uri)
        algorithms
        unless @algorithms.select{|v| v.xml_uri == xml_uri}.empty?
          return @algorithms.select{|v| v.xml_uri == xml_uri}.first
        end
        raise 'Unrecognized signature algorithm XML URI: ' + xml_uri
      end

      def get_instance_by_api_model(api_model)
        algorithms
        unless @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.empty?
          return @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.first
        end
        raise 'Unrecognized signature algorithm: ' + api_model
      end
    end
  end

  class RSASignatureAlgorithm < SignatureAlgorithm
    def initialize(digest_algorithm)
      case digest_algorithm
      when DigestAlgorithm.md5
        xml_uri = xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#rsa-md5'
        oid = Oids::MD5_WITH_RSA
      when digest_algorithm is DigestAlgorithm.sha1
        xml_uri = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
        oid = Oids::SHA1_WITH_RSA
      when digest_algorithm is DigestAlgorithm.sha256
        xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
        oid = Oids::SHA256_WITH_RSA
      when digest_algorithm is DigestAlgorithm.sha384
        xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha384'
        oid = Oids::SHA384_WITH_RSA
      when digest_algorithm is DigestAlgorithm.sha512
        xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha512'
        oid = Oids::SHA512_WITH_RSA
      else
        raise 'Unsupported digest algorithms: ' + digest_algorithm.oid
      end

      super(
        digest_algorithm.name + " with RSA",
        oid,
        xml_uri,
        digest_algorithm,
        PKAlgorithms::RSA)
    end
  end

  class PKAlgorithm
    attr_accessor :name, :oid

    def initialize(name, oid)
      @name = name
      @oid = oid
    end

    def rsa
      RSAPKAlgorithm.new
    end

    def self.algorithms
      return [rsa]
    end
    private_class_method :new, :algorithms
  end

  class RSAPKAlgorithm < PKAlgorithm
    def initialize
      super(PKAlgorithms::RSA, Oids::RSA)
    end
    class << RSAPKAlgorithm
      def get_signature_algorithm(digest_algorithm)
        RSASignatureAlgorithm.new(digest_algorithm)
      end
    end
  end
end