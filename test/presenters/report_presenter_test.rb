class ReportPresenterTest < ActiveSupport::TestCase

  def search
    @search ||= Search.new
  end

  def report
    @report ||= ReportPresenter.new(search)
  end

  def stubbed_developments
    Development.where(status: :projected)
  end

  test 'responds to search attributes' do
    %i( results developments ).each { |attribute|
      assert_respond_to report, attribute
    }
  end

  test '#developments returns all developments' do
    search.stub :results, Development.all do
      assert_equal Development.all, report.developments
      assert_equal Development.all, report.results
    end
  end

  test '#numeric_fields' do
    assert_respond_to report, :numeric_fields
  end

  test '#boolean_fields' do
    assert_respond_to report, :boolean_fields
  end

  test 'sums numeric fields by status' do
    search.stub :results, stubbed_developments do
      assert_equal 14, report.projected[:tothu]
    end
  end

  test 'counts boolean fields set to true' do
    search.stub :results, stubbed_developments do
      assert_equal 2, report.projected[:rdv]
    end
  end

  test 'can specify whether fields are nested' do
    skip
  end

  test 'shortcuts' do
    %i( projected planning in_construction completed ).each do |status|
      assert_equal report.statuses.send(status), report.send(status)
    end
  end

  test 'to CSV' do
    csv = report.to_csv
    assert_equal 'id,', csv[0..2]
    assert_equal 5, csv.lines.count
  end

end

# # booleans
# - mixed_use

# total_cost
# - employment
# emploss
