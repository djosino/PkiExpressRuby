module PkiExpress

  class Name

    attr_accessor :state_name, :pseudonym, :surname, :given_name, :locality,
                  :serial_number, :generation_qualifier, :email_address,
                  :organization_unit, :initials, :title, :common_name, :country,
                  :organization, :dn_qualifier

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

      unless model.nil?
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