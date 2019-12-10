module PkiExpress
  class CommandError < StandardError
    attr_accessor :name, :code, :inner_error

    def initialize(code, msg, inner_error=nil)
      super(msg)

      @name = self.class.name
      @code = code
      @inner_error = inner_error
    end

  end
end