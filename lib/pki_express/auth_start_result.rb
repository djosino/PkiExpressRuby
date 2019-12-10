module PkiExpress
  class AuthStartResult
    attr_accessor :digest_algorithm_name, :digest_algorithm_oid

    def initialize(model)
      @nonce_base64 = model.fetch(:toSignData)
      @digest_algorithm_name = model.fetch(:digestAlgorithmName)
      @digest_algorithm_oid = model.fetch(:digestAlgorithmOid)
    end

    # region The "nonce" accessors

    def nonce
      _get_nonce
    end

    def _get_nonce
      unless @nonce_base64
        return nil
      end

      Base64.decode64(@nonce_base64)
    end
    private :_get_nonce

    def nonce=(nonce)
      _set_nonce(nonce)
    end

    def _set_nonce(nonce)
      begin
        b64 = Base64.encode64(nonce)
      rescue Error
        raise 'The provided "nonce" is not valid.'
      end

      @nonce_base64 = b64
    end
    private :_set_nonce

    def nonce_base64
      _get_nonce_base64
    end

    def _get_nonce_base64
      @nonce_base64
    end
    private :_get_nonce_base64

    def nonce_base64=(nonce_base64)
      begin
        Base64.decode64(nonce_base64)
      rescue Error
        raise 'The provided "nonce_base64" is not Base64-encoded.'
      end

      @nonce_base64 = nonce_base64
    end

    #endregion

  end
end