class Development < ActiveRecord::Base
  extend Enumerize

  before_save :update_tagline
  before_save :clean_zip_code

  belongs_to :creator, class_name: :User
  has_one :walkscore # TODO

  has_many :edits
  has_many :flags
  has_many :crosswalks
  has_many :team_memberships, class_name: :DevelopmentTeamMembership
  has_many :team_members, through: :team_memberships, source: :organization

  has_and_belongs_to_many :programs

  validates :creator, presence: true

  serialize :fields, HashSerializer
  # Should get from self.all_fields, but comes up as nil.
  store_accessor :fields, [:year_compl, :prjarea,
    :rdv, :singfamhu, :twnhsmmult, :lgmultifam, :tothu, :gqpop,
    :clusteros, :ovr55, :mixeduse, :rptdemp, :emploss, :estemp,
    :commsf, :fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd,
    :fa_edinst, :fa_other, :other_rate, :fa_hotel, :hotelrms,
    :stalled, :phased, :onsitepark, :asofright, :total_cost, :private,
    :cancelled, :location, :affunits, :affordable, :ch40_id,
    :project_type, :feet_tall, :stories]

  STATUSES = [:projected, :planning, :in_construction, :completed]
  enumerize :status, :in => STATUSES, predicates: true

  alias_attribute :website, :project_url
  alias_attribute :zip, :zip_code

  def zip_code
    code = read_attribute(:zip_code)
    if code.length == 9
      "#{code[0..4]}-#{code[-4..-1]}"
    else
      code
    end
  end

  def mixed_use?
    any_residential_fields? && any_commercial_fields?
  end
  # TODO: Cache this in the database, to be used for searches.
  alias_method :mixed_use, :mixed_use?

  def history
    self.edits.where(state: 'applied').order(applied_at: :desc)
  end

  def pending_edits
    self.edits.where(state: 'pending').order(created_at: :asc)
  end

  def contributors
    _contributors = edits.where(state: 'applied').map(&:editor)
    _contributors << creator
    _contributors.uniq
  end

  def parcel
    OpenStruct.new(id: 12345)
  end

  def incentive_programs
    programs.where type: :incentive
  end

  def regulatory_programs
    programs.where type: :regulatory
  end

  def private?   ; read_attribute(:private) ; end

  def self.fields_hash
    @@fields_hash ||= build_fields_hash
  end

  def self.field_categories
    @@field_categories ||= build_field_categories
  end

  def self.all_fields
    @@_all ||= Array(self.fields_hash).map(&:first).map(&:to_sym)
  end

  [:name, :human_name, :description, :category].each do |method|
    define_method "#{method}_for" do |field|
      lookup_metadata field, method
    end
  end

  def lookup_metadata(field, method)
    self.class.fields_hash.fetch(field.to_s).send(method)
  end

  def any_residential_fields?
    @_any_residential ||= any_values(:residential).any?
  end

  def any_commercial_fields?
    @_any_commercial  ||= any_values(:commercial).any?
  end

  private

    def self.build_fields_hash
      pairs = YAML.load_file('db/metadata/development.yml').map{|e|
        [ e.fetch('name'), OpenStruct.new(e) ]
      }
      Hash[pairs]
    end

    def self.build_field_categories
      categories = []
      fields_hash.each_value {|v| categories << v.category}
      categories.uniq!
    end

    def self.build_category_helper_methods
      field_categories.each do |category|
        self.class.send(:define_method, "#{category}_fields") do
          Array(fields_hash).map{|a|
            a.first if a.last.category == category
          }.compact
        end
      end
    end
    self.build_category_helper_methods

    # Determine if `{type}_fields` (i.e. `boolean_fields`) have any
    # assigned values.
    def any_values(type)
      Development.send("#{type}_fields").map {|m| self.send(m)}
    end

    def update_tagline
      self.tagline = TaglineGenerator.new(self).perform!
    end

    def clean_zip_code
      self.zip_code = self.zip_code.to_s.gsub(/\D*/, '')
    end
end
