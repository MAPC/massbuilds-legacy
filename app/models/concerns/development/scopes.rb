class Development
  module Scopes
    extend ActiveSupport::Concern

    included do
      default_scope { includes(:place) }

      ranged_scopes :created_at, :updated_at, :height, :stories,
        :year_compl, :affordable, :prjarea, :singfamhu, :twnhsmmult,
        :lgmultifam, :tothu, :gqpop, :rptdemp, :emploss, :estemp, :commsf,
        :hotelrms, :onsitepark, :total_cost, :fa_ret, :fa_ofcmd,
        :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst, :fa_other, :fa_hotel

      boolean_scopes :rdv, :asofright, :ovr55, :clusteros, :phased,
        :stalled, :cancelled, :hidden, :cluster_or_open_space_development,
        :redevelopment, :as_of_right, :age_restricted, :hidden

      scope :close_to, CloseToQuery.new(self).scope
    end

  end
end
