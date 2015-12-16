class EditPresenter < Burgundy::Item
  include ActionView::Helpers::DateHelper

  def editor
    UserPresenter.new item.editor
  end

  def changes
    ChangePresenter.wrap item.fields
  end

  def time_ago
    "#{time_ago_in_words applied_at} ago"
  end
  alias_method :time, :time_ago

  def multiple_changes?
    changes.count > 1
  end

end