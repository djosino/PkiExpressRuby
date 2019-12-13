module PkiExpress
  class InstallationNotFoundError < CommandError

    def initialize(message, inner_error=nil)
      super(ErrorCodes::COMMAND_NOT_FOUND, message, inner_error)
    end
  end
end
