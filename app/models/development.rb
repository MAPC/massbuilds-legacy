class Development < ActiveRecord::Base
  has_many :edits
  has_many :flags

  serialize :fields, HashSerializer
  store_accessor :fields, :name, :address, :housing_units

  # TODO as we add more fields, potentially
  # def method_missing(method_name, *arguments, &block)
  #   fields.send(:fetch, method_name, &block)
  # rescue
  #   super
  # end
  # From https://robots.thoughtbot.com/always-define-respond-to-missing-when-overriding
  # def respond_to_missing?(method_name, include_private = false)
  #   method_name.to_s.start_with?('user_') || super
  # end

  # TODO Add definitions, metadata. Might be YML, could be in
  # config/locales.

  def history
    # Should be paginatable.
    # Oh, it's belongs as a separate resource, paginateable.
    self.edits.where(state: 'applied').order(:date)
  end

  def pending
    # See note in #history
    self.edits.where(state: 'pending').order(:date)
  end
end
