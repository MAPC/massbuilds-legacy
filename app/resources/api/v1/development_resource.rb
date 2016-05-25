require 'range_parser'

module API
  module V1
    class DevelopmentResource < JSONAPI::Resource

      attributes :name, :status, :tagline, :description, :project_url,
                 :year_compl,

                 :mixed_use, :rdv, :asofright, :ovr55, :clusteros, :hidden,

                 :redevelopment, :as_of_right, :age_restricted,
                 :cluster_or_open_space_development, :phased, :stalled,
                 :cancelled, :private,

                 :address, :neighborhood, :city, :state, :zip_code,
                 :full_address, :location, :latitude, :longitude,

                 :height, :stories, :prjarea, :total_cost,

                 :singfamhu, :twnhsmmult, :lgmultifam, :tothu, :gqpop,

                 :commsf, :rptdemp, :emploss, :estemp, :fa_ret, :fa_ofcmd,
                 :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst, :fa_other, :fa_hotel,
                 :affordable, :hotelrms, :onsitepark, :other_rate,

                 :street_view_latitude,
                 :street_view_longitude,
                 :street_view_heading,
                 :street_view_pitch

      before_save do
        @model.creator_id = context[:current_user].id if @model.new_record?
      end

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

      def self.creatable_fields(context)
        super - [:mixed_use, :walkscore]
      end

      def self.updatable_fields(context)
        super - [:mixed_use, :walkscore]
      end

      def city
        @model.municipality.try :name
      end

      # TODO: This is duplicated from the presenter.
      # How do we wrap the resource in a presenter?
      def full_address
        "#{@model.address}, #{@model.city} #{@model.state} #{@model.zip_code}"
      end

    end
  end
end
