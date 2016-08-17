class Development
  module FieldAliases
    extend ActiveSupport::Concern

    included do
      ALIASES = {
        cluster_or_open_space_development: :clusteros,
        redevelopment:   :rdv,
        as_of_right:     :asofright,
        age_restricted:  :ovr55,
        description:     :desc,
        website:         :project_url,
        zip:             :zip_code,
        hidden:          :private
      }.freeze

      ALIASES.each do |new_name, column|
        alias_attribute new_name, column
      end

      HOUSING_FIELDS = [:singfamhu, :twnhsmmult, :lgmultifam, :gqpop].freeze

      COMMERCIAL_FIELDS = [
        :fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst,
        :fa_other, :fa_hotel
      ].freeze
    end

  end
end
