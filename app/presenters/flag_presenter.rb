class FlagPresenter < Burgundy::Item
  include ActionView::Helpers::DateHelper

  def flagger
    UserPresenter.new item.flagger
  end

  def time_ago
    "#{time_ago_in_words created_at} ago"
  end
  alias_method :time, :time_ago

end
