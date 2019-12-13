class PkiItalyCertificateFields

  attr_accessor :certificate_type, :codice_fiscale, :id_carta

  def initialize(model)
    @certificate_type = nil
    @codice_fiscale = nil
    @id_carta = nil

    unless model.nil?
      @certificate_type = model.fetch(:certificateType)
      @codice_fiscale = model.fetch(:codiceFiscale)
      @id_carta = model.fetch(:idCarta)
    end
  end
end