module PkiExpress

  class PkiBrazilCertificateFields

    attr_accessor :rg_emissor_uf, :cnpj, :rg_numero, :oab_numero, :company_name,
                  :rg_emissor, :certificate_type, :cpf, :responsavel,
                  :date_of_birth, :oab_uf

    def initialize(model)
      @certificate_type = nil
      @cpf = nil
      @cnpj = nil
      @responsavel = nil
      @date_of_birth = nil
      @company_name = nil
      @rg_numero = nil
      @rg_emissor = nil
      @rg_emissor_uf = nil
      @oab_numero = nil
      @oab_uf = nil

      unless model.nil?
        @certificate_type = model.fetch(:certificateType)
        @cpf = model.fetch(:cpf)
        @cnpj = model.fetch(:cnpj)
        @responsavel = model.fetch(:responsavel)
        @date_of_birth = model.fetch(:dateOfBirth)
        @company_name = model.fetch(:companyName)
        @rg_numero = model.fetch(:rgNumero)
        @rg_emissor = model.fetch(:rgEmissor)
        @rg_emissor_uf = model.fetch(:rgEmissorUF)
        @oab_numero = model.fetch(:oabNumero)
        @oab_uf = model.fetch(:oabUF)
      end
    end

    def cpf_formatted
      if @cpf.nil?
        return ''
      end
      unless /^\d{11}$/.match(@cpf)
        return @cpf
      end
      "#{@cpf[0..2]}.#{@cpf[3..5]}.#{@cpf[6..8]}-#{@cpf[9..-1]}"
    end

    def cnpj_formatted
      if @cnpj.nil?
        return ''
      end
      unless /^\d{14}$/.match(@cnpj)
        return @cnpj
      end
      "#{@cnpj[0..1]}.#{@cnpj[2..4]}.#{@cnpj[5..7]}/#{@cnpj[8..11]}-#{@cnpj[12..-1]}"
    end
  end

end