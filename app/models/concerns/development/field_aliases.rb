class Development
  module FieldAliases
    extend ActiveSupport::Concern

    included do
      alias_attribute :description, :desc
      alias_attribute :website,     :project_url
      alias_attribute :zip,         :zip_code
      alias_attribute :hidden,      :private
    end

  end
end
