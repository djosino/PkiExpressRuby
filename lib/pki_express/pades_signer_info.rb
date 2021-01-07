module PkiExpress
  class PadesSignerInfo < CadesSignerInfo
    attr_accessor :is_document_timestamp, :signature_file_name
    def initialize(model)
      super(model)
      @is_document_timestamp = model.fetch(:isDocumentTimestamp)
      @signature_field_name = model.fetch(:signatureFieldName)
    end
  end
end