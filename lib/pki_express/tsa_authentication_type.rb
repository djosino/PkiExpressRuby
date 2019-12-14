module PkiExpress
  class TsaAuthenticationType < Enum
    NONE = 'None'
    BASIC_AUTH = 'BasicAuth'
    SSL = 'SSL'
    OAUTH_TOKEN = 'OAuthToken'

    VALUES = [
        NONE,
        BASIC_AUTH,
        SSL,
        OAUTH_TOKEN
    ]
  end
end