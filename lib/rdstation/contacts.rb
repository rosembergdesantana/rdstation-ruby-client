# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/contacts
  class Contacts
    include HTTParty
    
    def initialize(authorization_header:)
      @authorization_header = authorization_header
    end

    #
    # param uuid:
    #   The unique uuid associated to each RD Station Contact.
    #
    def by_uuid(uuid)
      response = self.class.get(base_url(uuid), headers: @authorization_header.to_h)
      ApiResponse.build(response)
    end

    def by_email(email)
      response = self.class.get(base_url("email:#{email}"), headers: @authorization_header.to_h)
      ApiResponse.build(response)
    end

    # The Contact hash may contain the following parameters:
    # :email
    # :name
    # :job_title
    # :linkedin
    # :facebook
    # :twitter
    # :personal_phone
    # :mobile_phone
    # :website
    # :tags
    def update(uuid, contact_hash)
      response = self.class.patch(base_url(uuid), :body => contact_hash.to_json, :headers => @authorization_header.to_h)
      ApiResponse.build(response)
    end

    #
    # param identifier:
    #   Field that will be used to identify the contact.
    # param identifier_value:
    #   Value to the identifier given.
    # param contact_hash:
    #   Contact data
    #
    def upsert(identifier, identifier_value, contact_hash)
      path = "#{identifier}:#{identifier_value}"
      response = self.class.patch(base_url(path), body: contact_hash.to_json, headers: @authorization_header.to_h)
      ApiResponse.build(response)
    end

    private

    def base_url(path = "")
      "https://api.rd.services/platform/contacts/#{path}"
    end
  end
end
