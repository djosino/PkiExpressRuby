module PkiExpress
  class ValidationError < CommandError

    def initialize(validation_results, inner_error=nil)
      super(ErrorCodes::VALIDATION_FAILED, validation_results, inner_error)
    end
  end
end
