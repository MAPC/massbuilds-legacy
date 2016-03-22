class EditSummaryPresenter < EditPresenter
  include ActionView::Helpers::DateHelper

  FIELD_COUNT = 3

  def changes
    ChangePresenter.wrap item.fields.first(FIELD_COUNT)
  end

  def more_than(count = FIELD_COUNT)
    item.fields.count - count
  end

  alias_method :more, :more_than

  def more?
    more > 0
  end

end
