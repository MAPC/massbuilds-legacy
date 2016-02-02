class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  validates :user, presence: true
  validates :subscribable, presence: true
  validate :requirements

  private

    def requirements
      sub = subscribable
      unless sub.is_a?(Development) || sub.respond_to?(:developments)
        errors.add :subscribable,
          "must be a Development or respond to #developments"
      end
    end
end
