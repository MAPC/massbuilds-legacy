class Development
  module FieldAliases
    extend ActiveSupport::Concern

    included do
      alias_attribute :redevelopment,  :rdv
      alias_attribute :as_of_right,    :asofright
      alias_attribute :age_restricted, :ovr55
      alias_attribute :cluster_or_open_space_development, :clusteros

      alias_attribute :description, :desc
      alias_attribute :website,     :project_url
      alias_attribute :zip,         :zip_code
      alias_attribute :hidden,      :private
    end

  end
end
