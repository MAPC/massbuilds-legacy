class FieldEdit < ActiveRecord::Base
  extend Enumerize

  belongs_to :edit
  delegate :development, to: :edit

  validates :name, presence: true
  validates :edit, presence: true
  validate :valid_change

  enumerize :name, in: Development.attribute_names

  # Storing as JSON allows us to store the
  # :to and :from attributes as any type.
  serialize :change, HashSerializer

  def from
    change.fetch(:from, nil)
  end

  def to
    change.fetch(:to)
  end

  def conflict
    development_current = development.send(name)
    return nil if development_current == from
    { current: development_current, from: from }
  end

  def conflict?
    conflict.present?
  end

  private

  def valid_change
    errors.add(:change, 'needs a key :to') unless has_right_keys?
    errors.add(:change, 'needs to be different') unless difference?
  end

  def has_right_keys?
    !change.fetch(:to).nil?
  rescue # doesn't have the key
    false
  end

  def difference?
    change[:from] != change[:to]
  end
end
