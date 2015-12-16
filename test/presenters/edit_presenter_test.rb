require 'test_helper'

class EditPresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= EditPresenter.new(edits(:one))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "#editor is presented" do
    assert_respond_to pres, :editor
    assert_respond_to pres.editor, :short_name
  end

  test "#changes" do
    assert_respond_to pres, :changes
  end

  test "#time_ago" do
    item.applied_at = 10.hours.ago
    assert_equal "about 10 hours ago", pres.time_ago
    assert_equal "about 10 hours ago", pres.time
  end
end