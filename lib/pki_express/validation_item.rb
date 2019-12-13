module PkiExpress

  class ValidationItem
    attr_accessor :type, :message, :detail, :inner_validation_results

    def initialize(model)
      @type = nil
      @message = nil
      @detail = nil
      @inner_validation_results = nil

      unless model.nil?
        @type = model.fetch(:type)
        @message = model.fetch(:message)
        @detail = model.fetch(:detail)

        inner_validation_results = model.fetch(:innerValidationResults)
        unless inner_validation_results.nil?
          @inner_validation_results = ValidationResults.new(inner_validation_results)
        end
      end
    end

    def to_str(indentation_level=0)
      to_s(indentation_level)
    end

    def to_s(indentation_level=0)
      text = @message
      unless @detail.nil?
        text += " (#{@detail})"
      end

      unless @inner_validation_results.nil?
        text += '\n'
        text += @inner_validation_results.to_s(indentation_level + 1)
      end

      text
    end
  end

end