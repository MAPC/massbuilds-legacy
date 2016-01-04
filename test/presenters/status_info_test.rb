require 'test_helper'

class StatusInfoTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= StatusInfo.new(developments(:one))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "#status_with_year" do
    item.year_compl = 2001
    { projected:       "Projected (est. 2001)",
      planning:        "Planning (est. 2001)",
      in_construction: "In Construction (est. 2001)",
      completed:       "Completed (2001)" }.each_pair do |status, text|
        item.status = status
        assert_equal text, pres.status_with_year
    end
  end

end
