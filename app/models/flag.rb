class Flag < ActiveRecord::Base
  belongs_to :flagger, class_name: :User
  belongs_to :development

  validates :flagger, presence: true
  validates :development, presence: true
  validates :reason, presence: :allow_blank,
    length: { minimum: 23, maximum: 450 }, if: -> { self.reason.present? }
  validate :valid_flagger

  private

    def valid_flagger
      if self.flagger == User.null
        errors.add :flagger, "must not be an anonymous user"
      end
    end
end
