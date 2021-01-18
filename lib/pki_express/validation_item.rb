module PkiExpress

  class ValidationItem
    attr_accessor :type, :message, :detail, :inner_validation_results

    def initialize(model)
      @type = nil
      @message = nil
      @detail = nil
      @inner_validation_results = nil

      if model
        @type = model.fetch(:type)
        @message = model.fetch(:message)
        @detail = model.fetch(:detail)

        inner_validation_results = model.fetch(:innerValidationResults)
        if inner_validation_results
          @inner_validation_results = ValidationResults.new(inner_validation_results)
        end
      end
    end

    def to_str(indentation_level=0)
      to_s(indentation_level)
    end

    def to_s(indentation_level=0)
      tab = "\t" * indentation_level
      text = tab + @message
      if @detail
        text += " (#{@detail})"
      end

      if @inner_validation_results
        text += "\n"
        text += @inner_validation_results.to_s(indentation_level + 1)
      end

      text
    end
  end

end