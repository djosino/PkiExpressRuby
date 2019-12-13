module PkiExpress
  class PadesVisualAutoPositioning < PadesVisualPositioning
    attr_accessor :container, :signature_rectangle_size, :row_spacing

    def initialize(page_number=nil, measurement_units=nil, container=nil, signature_rectangle_size=nil, row_spacing=nil)
      super(page_number, measurement_units)
      @container = container
      @signature_rectangle_size = signature_rectangle_size
      @row_spacing = row_spacing
    end

    def to_model
      model = super
      model['auto'] = {
          'container': @container&.to_model,
          'signatureRectangleSize': @signature_rectangle_size&.to_model,
          'rowSpacing': @row_spacing,
      }
      model
    end
  end
end