module PkiExpress

  class PkiExpressConfig
    attr_accessor :pki_express_home, :temp_folder, :transfer_data_folder
    @@single_temp_folder = nil

    def initialize(pki_express_home = nil, temp_folder = nil, transfer_data_folder = nil)
      if not temp_folder.nil? and Pathname.new(temp_folder).exist?
        @temp_folder = temp_folder
      else
        if @@single_temp_folder.nil?
          @@single_temp_folder = Dir.mktmpdir('pkie')
        end
        @temp_folder = @@single_temp_folder
      end

      if not transfer_data_folder.nil? and Pathname.new(transfer_data_folder).exist?
        @transfer_data_folder = transfer_data_folder
      else
        @transfer_data_folder = @temp_folder
      end

      @pki_express_home = pki_express_home
    end
  end
end
