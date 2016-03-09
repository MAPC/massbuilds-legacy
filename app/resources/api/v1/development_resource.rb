require 'range_parser'

module API
  module V1
    class DevelopmentResource < JSONAPI::Resource
      attributes :name, :status, :description
      attributes :redevelopment, :as_of_right, :age_restricted
      attributes :cluster_or_open_space_development
      attributes :description, :address, :city, :state, :zip_code, :full_address

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

      def description
        @model.desc
      end

      # TODO: This is duplicated from the presenter.
      def full_address
        "#{@model.address}, #{@model.city} #{@model.state} #{@model.zip_code}"
      end
    end
  end
end
