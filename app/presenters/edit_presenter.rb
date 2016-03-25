class EditPresenter < Burgundy::Item
  include ActionView::Helpers::DateHelper

  def editor
    UserPresenter.new item.editor
  end

  def changes
    ChangePresenter.wrap item.fields
  end

  # When we split the pending edit partials from the
  # applied edit partials, it may be advisable to also refactor
  # so this can accept a state. Therefore, we write
  # time_ago(:applied) to get applied_at, or time_ago(:created), etc.
  def time_ago
    "#{time_ago_in_words field_to_time} ago"
  end
  alias_method :time, :time_ago

  def multiple_changes?
    changes.count > 1
  end

  def single_change?
    changes.count == 1
  end

  def no_change?
    changes.count == 0
  end

  def more  ; 0     ; end
  def more? ; false ; end
  def more_than(*); false; end

  private

  def field_to_time
    applied? ? applied_at : created_at
  end

end
