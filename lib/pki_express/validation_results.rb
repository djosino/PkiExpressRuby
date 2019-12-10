module PkiExpress

  class ValidationResults
    attr_accessor :errors, :warnings, :passed_checks

    def initialize(model)
      @errors = []
      @warnings = []
      @passed_checks = []

      unless model.nil?
        errors = model.fetch(:errors)
        unless errors.nil?
          @errors = convert_items(errors)
        end

        warnings = model.fetch(:warnings)
        unless warnings.nil?
          @warnings = convert_items(warnings)
        end

        passed_checks = model.fetch(:passedChecks)
        unless passed_checks.nil?
          @passed_checks = convert_items(passed_checks)
        end
      end
    end

    def to_str(indentation_level = 0)
      to_s(indentation_level)
    end

    def to_s(indentation_level = 0)
      item_indent = '\t' * indentation_level
      text = ''

      text += get_summary(indentation_level)
      if has_errors
        text += "\n#{item_indent}Errors:\n"
        text += join_items(@errors, indentation_level)
      end

      if has_warnings
        text += "\n#{item_indent}Warnings:\n"
        text += join_items(@warnings, indentation_level)
      end

      if not @passed_checks.nil? and @passed_checks.length > 0
        text += "\n#{item_indent}Passed Checks:\n"
        text += join_items(@passed_checks, indentation_level)
      end

      text
    end

    def is_valid
      not has_errors
    end

    def checks_performed
      @errors.length + @warnings.length + @passed_checks.length
    end

    def has_errors
      @errors.length > 0
    end

    def has_warnings
      @errors.length > 0
    end

    def get_summary(indentation_level=0)
      item_indent = '\t' * indentation_level
      text = "#{item_indent}Validation Results: "

      if checks_performed == 0
        text += 'no checks performed'
      else
        text += "#{checks_performed} checks performed"
        if has_errors
          text += ", #{@errors.length} errors"
        end
        if has_warnings
          text += ", #{@warnings.length} warnings"
        end
        if not @passed_checks.nil? and @passed_checks.length
          if not has_errors and not has_warnings
            text += ', all passed'
          else
            text += ", #{@passed_checks.length} passed"
          end
        end
      end

      text
    end

    def convert_items(items)
      items.map { |i| ValidationItem.new(i) }
    end

    def join_items(items, indentation_level=0)
      text = ''
      is_first = true
      item_indent = '\t' * indentation_level

      items.each do |i|
        if is_first
          is_first = false
        else
          text += '\n'
        end
        text += item_indent + '- '
        text += i.to_s(indentation_level)
      end

      text
    end
  end

end