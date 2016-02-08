class Flag < ActiveRecord::Base
  extend Enumerize

  belongs_to :development
  belongs_to :flagger,  class_name: :User, foreign_key: :flagger_id
  belongs_to :resolver, class_name: :User, foreign_key: :resolver_id

  validates :flagger, presence: true
  validates :development, presence: true
  validates :reason, presence: :allow_blank,
    length: { minimum: 23, maximum: 450 }, if: -> { reason.present? }
  validate :valid_flagger

  enumerize :state, in: [:pending, :open, :resolved], default: :pending,
    predicates: true

  def submitted
    self.state = :open
  end

  def resolved
    assert_resolvable
    self.state = :resolved
  end

  def resolvable?
    # Valid, not resolved, and has a resolver.
    valid? && !resolved? && resolver.present?
  end

  private

    def valid_flagger
      if self.flagger == User.null
        errors.add :flagger, 'must not be an anonymous user'
      end
    end

    def assert_resolvable
      unless resolvable?
        raise StandardError, "Flag #{id} is not resolvable"
      end
    end

end
