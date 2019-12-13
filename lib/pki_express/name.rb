module PkiExpress

  class Name

    attr_accessor :country, :organization, :organization_unit, :dn_qualifier,
                  :state_name, :common_name, :serial_number, :locality, :title,
                  :surname, :given_name, :initials, :pseudonym,
                  :generation_qualifier, :email_address

    def initialize(model)
      @country = nil
      @organization = nil
      @organization_unit = nil
      @dn_qualifier = nil
      @state_name = nil
      @common_name = nil
      @serial_number = nil
      @locality = nil
      @title = nil
      @surname = nil
      @given_name = nil
      @initials = nil
      @pseudonym = nil
      @generation_qualifier = nil
      @email_address = nil


      if model
        @country = model.fetch(:country)
        @organization = model.fetch(:organization)
        @organization_unit = model.fetch(:organizationUnit)
        @dn_qualifier = model.fetch(:dnQualifier)
        @state_name = model.fetch(:stateName)
        @common_name = model.fetch(:commonName)
        @serial_number = model.fetch(:serialNumber)
        @locality = model.fetch(:locality)
        @title = model.fetch(:title)
        @surname = model.fetch(:surname)
        @given_name = model.fetch(:givenName)
        @initials = model.fetch(:initials)
        @pseudonym = model.fetch(:pseudonym)
        @generation_qualifier = model.fetch(:generationQualifier)
        @email_address = model.fetch(:emailAddress)
      end
    end
  end

end