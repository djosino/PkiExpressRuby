module PkiExpress
  class SignatureStartResult
    attr_accessor :to_sign_hash, :digest_algorithm_name, :digest_algorithm_oid,
                  :transfer_file_id

    def initialize(model, transfer_file_id)
      @to_sign_hash = model.fetch(:toSignHash)
      @digest_algorithm_name = model.fetch(:digestAlgorithmName)
      @digest_algorithm_oid = model.fetch(:digestAlgorithmOid)
      @transfer_file_id = transfer_file_id
    end
  end
end