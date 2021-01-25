module PkiExpress
  class PadesSignature
    attr_accessor :signers

    def initialize(model)
      @signers = []

      unless model.nil?
        signers = model.fetch(:signers)
        if signers
          @signers = signers.map { |s| PadesSignerInfo.new(s) }
        end
      end
    end

  end
end