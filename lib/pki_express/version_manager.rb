module PkiExpress

  class VersionManager
    attr_reader :min_version

    def initialize
      @min_version = '0.0.0'
    end

    def require_version(candidate)
      if Gem::Version.new(candidate) > Gem::Version.new(@min_version)
        @min_version = candidate
      end
    end

    def require_min_version_flag?
      Gem::Version.new(@min_version) > Gem::Version.new('1.3')
    end
  end

end