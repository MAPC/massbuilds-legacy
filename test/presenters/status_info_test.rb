require 'test_helper'

class StatusInfoTest < ActiveSupport::TestCase

  def presenter
    @_presenter ||= StatusInfo.new(developments(:one))
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test '#status_with_year' do
    Time.stub :now, Time.new(2000) do
      item.year_compl = 2100
      statuses.each_pair do |status, text|
        item.status = status
        assert_equal text, pres.status_with_year
      end
    end
  end

  test 'year or year range' do
    Time.stub :now, Time.new(2000) do
      [{ year: 2000, expected: '2000'      },
       { year: 2009, expected: '2009'      },
       { year: 2010, expected: '2010-2020' },
       { year: 2011, expected: '2010-2020' },
       { year: 1989, expected: '1989'      },
       { year: 2100, expected: '2100-2110' },
       { year: 2099, expected: '2090-2100' }].each do |set|
        item.year_compl = set[:year]
        assert_equal set[:expected], pres.year
      end
    end
  end

  test 'status icon' do
    item.status = :projected
    assert_equal :find,  pres.status_icon
  end

  def statuses
    { projected:       'Projected (for 2100-2110)',
      planning:        'Planning (est. 2100-2110)',
      in_construction: 'In Construction (est. 2100-2110)',
      completed:       'Completed (2100)' }
  end

end
