require 'pathname'

module PkiExpress

  class PkiExpressConfig
    attr_accessor :pki_express_home, :temp_folder, :transfer_data_folder
    @@single_temp_folder = nil

    def initialize(pki_express_home = nil, temp_folder = nil, transfer_data_folder = nil)
      if not temp_folder.nil? 
        if Pathname.new(temp_folder).exist?
          @temp_folder = temp_folder
        else
          raise ArgumentError.new "the provided temp_folder is not valid"
        end
      else
        if @@single_temp_folder.nil?
          @@single_temp_folder = Dir.mktmpdir('pkie')
        end
        @temp_folder = @@single_temp_folder
      end

      if not transfer_data_folder.nil? 
        if Pathname.new(transfer_data_folder).exist?
          @transfer_data_folder = transfer_data_folder
        else
          raise ArgumentError.new "the provided transfer_data_folder is not valid"
        end
      else
        @transfer_data_folder = @temp_folder
      end

      if not pki_express_home.nil? and not File.directory?(pki_express_home)
        raise ArgumentError.new "the provided pki_express_home is not valid"
      end
      @pki_express_home = pki_express_home
    end
  end
end
