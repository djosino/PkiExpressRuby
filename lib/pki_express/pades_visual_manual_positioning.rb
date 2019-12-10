module PkiExpress
  class PadesVisualManualPositioning < PadesVisualPositioning
    attr_accessor :signature_rectangle

    def initialize(page_number=nil, measurement_units=nil, signature_rectangle=nil)
      super(page_number, measurement_units)
      @signature_rectangle = signature_rectangle
    end

    def to_model
      model = super
      model['manual'] = @signature_rectangle&.to_model
      model
    end

  end
end