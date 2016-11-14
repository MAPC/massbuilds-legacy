require 'net/http'

# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/
# HTTP Codes: http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTPResponse.html

class ActiveRecord::Base
  def self.validates_uri_existence_of(*attr_names)
    # Add { on: :save } to options in order to only do this validation upon saving.
    configuration = { message: "is not valid or not responding" }

    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

    validates_each(attr_names, configuration) do |record, attribute, value|
      begin  # Check header response
        case Net::HTTP.get_response(URI.parse(value))
        when Net::HTTPSuccess, Net::HTTPRedirection then true
        else record.errors.add(attribute, configuration[:message]) and false
        end
      rescue # Recover on DNS failures.
        record.errors.add(attribute, configuration[:message]) and false
      end
    end

  end
end
