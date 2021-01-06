module PkiExpress
  class DigestAlgorithms < Enum
    MD5 = 'MD5'
    SHA1 = 'SHA1'
    SHA256 = 'SHA256'
    SHA384 = 'SHA384'
    SHA512 = 'SHA512'
  end

  class DigestAlgorithm
    attr_accessor :byte_length, :api_model, :xml_uri, :oid, :name

    def self.populate_algorithms
      unless @algorithms
        @algorithms = []
        @algorithms << MD5DigestAlgorithm.new
        @algorithms << SHA1DigestAlgorithm.new
        @algorithms << SHA256DigestAlgorithm.new
        @algorithms << SHA384DigestAlgorithm.new
        @algorithms << SHA512DigestAlgorithm.new
      end
    end
    private_class_method :populate_algorithms

    class << DigestAlgorithm
      def get_instance_by_name(name)
        populate_algorithms
        unless @algorithms.select{|v| v.name == name}.empty?
          return @algorithms.select{|v| v.name == name}.first
        end
        raise 'Unrecognized digest algorithm name: ' + name
      end

      def get_instance_by_oid(oid)
        populate_algorithms
        unless @algorithms.select{|v| v.oid == oid}.empty?
          return @algorithms.select{|v| v.oid == oid}.first
        end
        raise 'Unrecognized digest algorithm oid: ' + oid
      end

      def get_instance_by_xml_uri(xml_uri)
        populate_algorithms
        unless @algorithms.select{|v| v.xml_uri == xml_uri}.empty?
          return @algorithms.select{|v| v.xml_uri == xml_uri}.first
        end
        raise 'Unrecognized digest algorithm XML URI: ' + xml_uri
      end

      def get_instance_by_api_model(api_model)
        populate_algorithms
        unless @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.empty?
          return @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.first
        end
        raise 'Unrecognized digest algorithm XML URI: ' + api_model
      end
    end
  end

  class MD5DigestAlgorithm < DigestAlgorithm
    def initialize
      @name = DigestAlgorithms.MD5
      @oid = Oids.MD5
      @byte_length = 16
      @api_model = 'md5'
      @xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#md5'
    end
  end

  class SHA1DigestAlgorithm < DigestAlgorithm
    def initialize
      @name = DigestAlgorithms.SHA1
      @oid = Oids.SHA1
      @byte_length = 20
      @api_model = 'sha1'
      @xml_uri = 'http://www.w3.org/2000/09/xmldsig#sha1'
    end
  end

  class SHA256DigestAlgorithm < DigestAlgorithm
    def initialize
      @name = DigestAlgorithms.SHA256
      @oid = Oids.SHA256
      @byte_length = 32
      @api_model = 'sha256'
      @xml_uri = 'http://www.w3.org/2001/04/xmlenc#sha256'
    end
  end

  class SHA384DigestAlgorithm < DigestAlgorithm
    def initialize
      @name = DigestAlgorithms.SHA384
      @oid = Oids.SHA384
      @byte_length = 48
      @api_model = 'sha384'
      @xml_uri = 'http://www.w3.org/2001/04/xmldsig-more#sha384'
    end
  end

  class SHA512DigestAlgorithm < DigestAlgorithm
    def initialize
      @name = DigestAlgorithms.SHA512
      @oid = Oids.SHA512
      @byte_length = 64
      @api_model = 'sha512'
      @xml_uri = 'http://www.w3.org/2001/04/xmlenc#sha512'
    end
  end
end