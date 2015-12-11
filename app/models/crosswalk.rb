class Crosswalk < ActiveRecord::Base
  belongs_to :organization
  belongs_to :development

  validates :organization, presence: true
  validates :development,  presence: true
  validates :internal_id,  presence: true

  def url
    return nil unless organization.has_url_template?
    organization.url_parser.expand(id: internal_id)
  end
end
