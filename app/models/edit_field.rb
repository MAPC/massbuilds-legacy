class EditField < ActiveRecord::Base
  extend Enumerize

  belongs_to :edit
  delegate :development, to: :edit

  validates :name, presence: true
  validates :edit, presence: true
  validate :valid_change

  enumerize :name, :in => Development.all_fields

  serialize :change, HashSerializer

  def from
    self.change.fetch(:from, nil)
  end

  def to
    self.change.fetch(:to)
  end

  def conflict
    _from = development.send(name)
    {current: _from, from: from} if _from != from
  end

  def conflict?
    conflict.present?
  end

  private

    def valid_change
      errors.add(:change, "needs a key :to") unless has_right_keys?
      errors.add(:change, "needs to be different") unless difference?
    end

    def has_right_keys?
      self.change.fetch(:to) { false }
    end

    def difference?
      self.change[:from] != self.change[:to]
    end
end
