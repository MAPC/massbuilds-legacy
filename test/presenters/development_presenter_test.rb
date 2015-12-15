require 'test_helper'

class DevelopmentPresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= DevelopmentPresenter.new(developments(:one))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "#contributors" do
    assert_respond_to pres, :contributors
  end

  test "#recent_history" do
    assert_respond_to pres, :recent_history
  end

  test "#related" do
    assert_respond_to pres, :related
  end

  test "related developments are also wrapped" do
    pres.related.each do |development|
      assert_respond_to development, :recent_history
    end
  end

  test "status_with_year" do
    pres.item.year_compl = 2001
    { projected:       "Projected (est. 2001)",
      planning:        "Planning (est. 2001)",
      in_construction: "In Construction (est. 2001)",
      completed:       "Completed (2001)" }.each_pair do |status, text|
        pres.item.status = status
        assert_equal text, pres.status_with_year
    end
  end

  test "#team" do
    assert_respond_to pres, :team
  end

  test "employment with estimated only" do
    item.rptdemp = nil
    item.estemp  = 1000
    assert_equal 1000, pres.employment
  end

  test "employment with reported only" do
    item.rptdemp = 1001
    item.estemp  = nil
    assert_equal 1001, pres.employment
  end

  test "employment with estimated and reported uses reported" do
    item.rptdemp = 0
    item.estemp  = 1
    assert_equal 0, pres.employment
  end

  test "employment works with strings" do
    item.rptdemp = '100'
    item.estemp  = '101'
    assert_equal 100, pres.employment
  end

  test "employment with nothing given returns nil, not an integer" do
    item.rptdemp = item.estemp = nil
    assert_equal nil, pres.employment
    refute_equal 0,   pres.employment
  end

  test "crosswalks" do
    assert_respond_to pres, :crosswalk_links
  end

  test "tagline" do
    assert_respond_to pres, :tagline
  end

end