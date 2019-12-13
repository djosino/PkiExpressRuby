module PkiExpress
  class PadesVisualPositioning
    attr_reader :measurement_units
    attr_accessor :page_number, :page_optimization

    def initialize(page_number=nil, measurement_units=nil)
      @page_number = page_number
      @measurement_units = measurement_units
      @page_optimization = nil
    end

    def measurement_units=(value)
      unless PadesMeasurementUnits.contains?(value)
        raise 'The provided "measurement_units" is not valid. Try using PadesMeasurementUnits constants'
      end

      @measurement_units = value
    end

    def to_model
      {
          'pageNumber': @page_number,
          'measurementUnits': @measurement_units,
          'pageOptimization': @page_optimization&.to_model
      }
    end
  end
end