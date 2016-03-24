class DevelopmentForm
  include ActiveModel::Model
  include Virtus.model

  attribute :id, Integer

  attribute :address,  String
  attribute :city,     String
  attribute :state,    String
  attribute :zip_code, String

  attribute :name,   String
  attribute :status, String
  attribute :total_cost, Integer

  [:rdv, :asofright, :ovr55, :clusteros, :phased, :stalled].each { |b|
    attribute b, Boolean, default: false
  }

  # Metaprogramming way to do all of the attributes.
  # Development.columns_hash do |name, meta|
  #   name = name.to_sym
  #   type = Kernel.const_get(meta.type.to_s.capitalize)
  #   attribute name, type
  # end

  def initialize(current_user)
    @current_user = current_user
  end

  # Access the development record after it's saved
  attr_reader :development

  # Validations
  # validates :name, presence: true
  # validates :total_cost, numericality: { only_integer: true, greater_than: 0 }

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Development')
  end

  def submit(id, params)
    @development = Development.find(id)
    # Validations get skipped by assigning attributes to
    @development.assign_attributes(params)
    @development.freeze # Prevent saving
    save
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    # Without a transaction, this becomes a dangling edit with
    # no changes, which causes an error in our timid pending
    # edits template.
    ActiveRecord::Base.transaction do
      edit = @development.edits.create!(editor: @current_user)
      @development.changes.each_pair do |name, diff|
        edit.fields.create!(name: name,
          change: { from: diff.first, to: diff.last })
      end
    end
  end

end
