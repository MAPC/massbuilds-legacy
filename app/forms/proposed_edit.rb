class ProposedEdit < Form

  def initialize(development)
    @development = development
  end

  # Trick form helpers into using the development path
  def self.model_name
    ActiveModel::Name.new(self, nil, "Development")
  end

  def development
    @development || Development.new
  end

  # This gnarly duplication is a clear indication of the need
  # for some separate object that holds the logic about
  # these attributes. I'm thinking of moving the metadata logic
  # into lib from models/development.
  all_attributes = [:name, :status, :year_compl, :prjarea,
   :rdv, :singfamhu, :twnhsmmult, :lgmultifam, :tothu, :gqpop,
   :clusteros, :ovr55, :mixeduse, :rptdemp, :emploss, :estemp,
   :commsf, :fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd,
   :fa_edinst, :fa_other, :other_rate, :fa_hotel, :hotelrms, :desc,
   :project_url, :mapc_notes, :stalled, :phased, :onsitepark,
   :asofright, :total_cost, :private, :cancelled, :location,
   :tagline, :address, :city, :state, :zip_code, :affunits,
   :affordable, :ch40_id, :project_type, :feet_tall, :stories]

  all_attributes.each do |attrib|
    attribute(attrib)
  end

  delegate *all_attributes, to: :development
  delegate :description_for, :stats, :human_name_for, :parcel, :team_memberships, to: :development

  def stats
    [:tothu, :commsf, :prjarea, :stories, :feet_tall]
  end

  def commercial_table_fields
    %i( fa_ret fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst fa_hotel fa_other )
  end

  def employment_table_fields
    %i( employment hotelrms )
  end

  def any_commercial_table_fields?
    any_fields? :commercial
  end

  def any_employment_table_fields?
    any_fields? :employment
  end

  private

    def persist!
    end

end
