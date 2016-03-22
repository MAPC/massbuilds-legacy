require 'range_parser'

module API
  module V1
    class DevelopmentResource < JSONAPI::Resource

      attributes :name, :status, :description
      attributes :redevelopment, :as_of_right, :age_restricted,
                 :cluster_or_open_space_development, :phased, :stalled,
                 :cancelled, :private
      attributes :description, :address, :neighborhood, :city, :state,
                 :zip_code, :full_address, :project_url, :tagline,
                 :location
      attributes :height, :stories, :year_compl, :prjarea, :total_cost
      attributes :singfamhu, :twnhsmmult, :lgmultifam, :tothu, :gqpop
      attributes :commsf, :rptdemp, :emploss, :estemp, :fa_ret, :fa_ofcmd,
                 :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst, :fa_other, :fa_hotel,
                 :affordable, :hotelrms, :onsitepark, :other_rate

      has_many :team_memberships

      # Filters
      range_filters :created_at, :updated_at, :height, :stories,
        :year_compl, :affordable, :prjarea, :singfamhu, :twnhsmmult,
        :lgmultifam, :tothu, :gqpop, :rptdemp, :emploss, :estemp, :commsf,
        :hotelrms, :onsitepark, :total_cost, :fa_ret, :fa_ofcmd,
        :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst, :fa_other, :fa_hotel

      boolean_filters :rdv, :asofright, :ovr55, :clusteros, :phased,
        :stalled, :cancelled, :hidden

      filter :status

      # TODO: Warning, possibility for bloat. May warrant a presenter.
      def redevelopment
        @model.rdv
      end

      def as_of_right
        @model.asofright
      end

      def age_restricted
        @model.ovr55
      end

      def cluster_or_open_space_development
        @model.clusteros
      end

      def city
        { name: @model.city.name } # TODO: Add muni_id
      end

      # TODO: This is duplicated from the presenter.
      # How do we wrap the resource in a presenter?
      def full_address
        "#{@model.address}, #{@model.city} #{@model.state} #{@model.zip_code}"
      end

    end
  end
end
