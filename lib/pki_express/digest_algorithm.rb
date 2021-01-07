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
    def initialize(name, oid, byte_length, api_model, xml_uri)
      @name = name
      @oid = oid
      @byte_length = byte_length
      @api_model = api_model
      @xml_uri = xml_uri
    end

    def md5
      unless @md5
        @md5 = new(
          DigestAlgorithms.MD5,
          Oids::MD5,
          16,
          'md5',
          'http://www.w3.org/2001/04/xmldsig-more#md5')
      end
    end

    def sha1
      unless @sha1
        @sha1 = new(
          DigestAlgorithms.SHA1,
          Oids::SHA1,
          20,
          'sha1',
          'http://www.w3.org/2000/09/xmldsig#sha1')
      end
    end

    def sha256
      unless @sha256
        @sha256 = new(
          DigestAlgorithms.SHA256,
          Oids::SHA256,
          32,
          'sha256',
          'http://www.w3.org/2001/04/xmlenc#sha256')
      end
    end

    def sha384
      unless @sha384
        @sha384 = new(
          DigestAlgorithms.SHA384,
          Oids::SHA384,
          48,
          'sha384',
          'http://www.w3.org/2001/04/xmldsig-more#sha384')
      end
    end

    def sha512
      unless @sha512
        @sha512 = new(
          DigestAlgorithms.SHA512,
          Oids::SHA512,
          64,
          'sha512',
          'http://www.w3.org/2001/04/xmlenc#sha512')
      end
    end

    def self.get_algorithms
      return [md5, sha1, sha256, sha384, sha512]
    end
    private_class_method :get_algorithms, :new

    class << DigestAlgorithm
      def get_instance_by_name(name)
        get_algorithms
        unless @algorithms.select{|v| v.name == name}.empty?
          return @algorithms.select{|v| v.name == name}.first
        end
        raise 'Unrecognized digest algorithm name: ' + name
      end

      def get_instance_by_oid(oid)
        get_algorithms
        unless @algorithms.select{|v| v.oid == oid}.empty?
          return @algorithms.select{|v| v.oid == oid}.first
        end
        raise 'Unrecognized digest algorithm oid: ' + oid
      end

      def get_instance_by_xml_uri(xml_uri)
        get_algorithms
        unless @algorithms.select{|v| v.xml_uri == xml_uri}.empty?
          return @algorithms.select{|v| v.xml_uri == xml_uri}.first
        end
        raise 'Unrecognized digest algorithm XML URI: ' + xml_uri
      end

      def get_instance_by_api_model(api_model)
        get_algorithms
        unless @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.empty?
          return @algorithms.select{|v| v.api_model.downcase == api_model.downcase}.first
        end
        raise 'Unrecognized digest algorithm: ' + api_model
      end
    end
  end
end