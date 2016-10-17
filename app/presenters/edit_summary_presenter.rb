class EditSummaryPresenter < EditPresenter
  include ActionView::Helpers::DateHelper

  FIELD_COUNT = 3

  def changes
    # Only show the first three changes.
    ChangePresenter.wrap item.fields.first(FIELD_COUNT)
  end

  # Are there more edits to show?
  def more_than(count = FIELD_COUNT)
    item.fields.count - count
  end

  alias_method :more, :more_than

  # TODO: Where is this used?
  def more?
    more > 0
  end

end
