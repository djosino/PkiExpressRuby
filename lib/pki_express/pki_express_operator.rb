require 'shellwords'
require 'open3'

module PkiExpress

  class PkiExpressOperator
    attr_accessor :offline, :trust_lacuna_test_root, :signature_policy,
                  :timestamp_authority, :culture, :time_zone

    def initialize(config = PkiExpressConfig.new)
      @temp_files = []
      @file_references = {}

      @config = config
      @version_manager = VersionManager.new
      @trusted_roots = []
      @offline = false
      @trust_lacuna_test_root = false
      @signature_policy = nil
      @timestamp_authority = nil
      @culture = nil
      @time_zone = nil

      ObjectSpace.define_finalizer(self, self.class.method(:finalize))
    end

    def self.finalize
      @temp_files.each do |file|
        File.delete(file) if File.exist?(file)
      end
    end

    def add_file_reference(key, reference_path)

      if reference_path.nil?
        raise ArgumentError.new('The provided reference path is not valid')
      end

      unless File.exists?(reference_path)
        raise ArgumentError.new('The provided reference file was not found')
      end

      @file_references[key] = reference_path
    end

    def add_trusted_root(root_path)

      if root_path.nil?
        raise ArgumentError.new('The provided trusted root path is not valid')
      end

      unless File.exists?(root_path)
        raise ArgumentError.new("The provided trusted root path doesn't exist: #{root_path}")
      end

      @trusted_roots.append(root_path)
    end

    protected
    def invoke_plain(command, args = [])
      invoke(command, args, true)
    end

    def invoke(command, args = [], plain_output = false)

      # Add PKI Express invocation arguments.
      cmd_args = []
      get_pki_express_invocation.each do |arg|
        cmd_args.append(arg)
      end

      # Add PKI Express command.
      cmd_args.append(command)

      # Add PKI Express arguments.
      cmd_args.concat args

      # Add file references if added.
      unless @file_references.nil?
        @file_references.each do |key, value|
          cmd_args.append('--file-reference')
          cmd_args.append("#{key}=#{value}")
        end
      end

      # Add trusted roots if added.
      unless @trusted_roots.nil?
        @trusted_roots.each do |trusted_root|
          cmd_args.append('--trust-root')
          cmd_args.append(trusted_root)
        end
      end

      # Add trust Lacuna test root if set.
      if @trust_lacuna_test_root
        cmd_args.append('--trust-test')
      end

      # Add offline option if provided.
      if @offline
        cmd_args.append('--offline')
        # This option can only be used on versions greater than 1.2 of the
        # PKI Express.
        @version_manager.require_version('1.2')
      end

      # Add base64 output option
      unless plain_output
        cmd_args.append('--base64')
      end

      unless @culture.nil?
        cmd_args.append('--culture')
        cmd_args.append(@culture)
        # This option can only be used on versions 
        # greater than 1.10 of the PKI Express.
        @version_manager.require_version('1.10')
      end

      unless @time_zone.nil?
        cmd_args.append('--timezone')
        cmd_args.append(@time_zone)
        # This option can only be used on versions 
        # greater than 1.10 of the PKI Express.
        @version_manager.require_version('1.10')
      end

      # Verify the necessity of using the --min-version flag.
      if @version_manager.require_min_version_flag?
        cmd_args.append('--min-version')
        cmd_args.append(@version_manager.min_version.to_s)
      end

      # Escape command args
      escaped = []
      cmd_args.each do |arg|
        escaped.append("\"#{arg}\"")
        # escaped.append(Shellwords.escape(arg))
      end

      # Perform the "dotnet" command.
      stdout, _stderr, status = Open3.capture3(escaped.join(' '))

      if status != 0
        if status === ErrorCodes::BAD_SYNTAX and @version_manager.min_version > '1.0'
          raise CommandError.new(status, "#{stdout}  >>>>> TIP: This operation requires PKI Express #{@version_manager.min_version}, please check your PKI Express version.")
        end
        if status === ErrorCodes::VALIDATION_FAILED
          raise ValidationError.new(stdout)
        end
        if status === ErrorCodes::COMMAND_NOT_FOUND
          raise InstallationNotFoundError.new("Could not find PKI Express's installation.")
        end

        raise CommandError.new(status, stdout)
      end

      # Return stdout if the command executed with success.
      stdout
    end

    def get_pki_express_invocation

      # Identify OS.
      if (/linux/ =~ RUBY_PLATFORM) != nil
        system = :linux
      elsif (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
        system = :win
      else
        raise Error.new("Unsupported OS: #{RUBY_PLATFORM}")
      end

      # Verify if hte PKI Express home is set on configuration
      home = @config.pki_express_home
      if not home.nil?

        if system == :linux
          unless File.exists?(File.expand_path('pkie.dll', home))
            raise InstallationNotFoundError.new("The file pkie.dll could not be found on directory #{home}")
          end
        elsif not File.exists?(File.expand_path('pkie.exe', home))
          raise InstallationNotFoundError.new("The file pkie.exe could not be found on directory #{home}")
        end

      elsif system == :win

        if File.exists?(File.join(ENV['ProgramW6432'], 'Lacuna Software', 'PKI Express', 'pkie.exe'))
          home = File.join(ENV['ProgramW6432'], 'Lacuna Software', 'PKI Express')
        elsif File.exists?(File.join(ENV['ProgramFiles(x86)'], 'Lacuna Software', 'PKI Express', 'pkie.exe'))
          home = File.join(ENV['ProgramFiles(x86)'], 'Lacuna Software', 'PKI Express')
        elsif File.exists?(File.join(ENV['LOCALAPPDATA'], 'Lacuna Software', 'PKI Express', 'pkie.exe'))
          home = File.join(ENV['LOCALAPPDATA'], 'Lacuna Software', 'PKI Express')
        elsif File.exists?(File.join(ENV['LOCALAPPDATA'], 'Lacuna Software (x86)', 'PKI Express', 'pkie.exe'))
          home = File.join(ENV['LOCALAPPDATA'], 'Lacuna Software (x86)', 'PKI Express')
        end

        if home.nil?
          raise InstallationNotFoundError.new('Could not determine the
            installation folder of PKI Express. If you installed PKI Express on
            a custom folder, make sure your chosen folder are specified on the
            PkiExpressConfig object.')
        end
      end

      if system == :linux
        unless home.nil?
          return ['dotnet', File.expand_path('pkie.dll', home)]
        end

        return ['pkie']
      end
      [File.expand_path('pkie.exe', home)]
    end

    def parse_output(data_base64)
      json_buff = Base64.decode64(data_base64)
      JSON.parse(json_buff, symbolize_names: true)
    end

    def create_temp_file
      file = Tempfile.new('pkie', @config.temp_folder)
      temp_path = file.path
      file.close
      @temp_files.append(temp_path)
      temp_path
    end

    def get_transfer_filename
      # Generate 16 random bytes. Return a string containing the hex decimals of
      # this array.
      SecureRandom.hex(16)
    end
  end
end
