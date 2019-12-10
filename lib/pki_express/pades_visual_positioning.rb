module PkiExpress
  class PadesVisualPositioning
    attr_accessor :page_number, :measurement_units, :page_optimization

    def initialize(page_number=nil, measurement_units=nil)
      @page_number = page_number
      @measurement_units = measurement_units
      @page_optimization = nil
    end

    def to_model
      measurement_units = nil
      if @measurement_units
        case @measurement_units
        when :centimeters
          measurement_units = 'Centimeters'
        when :pdf_points
          measurement_units = 'PdfPoints'
        else
          raise 'The provided "measurement_units" value is not valid'
        end
      end
      {
          'pageNumber': @page_number,
          'measurementUnits': measurement_units,
          'pageOptimization': @page_optimization&.to_model
      }
    end
  end
end