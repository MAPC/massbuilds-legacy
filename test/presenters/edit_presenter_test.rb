require 'test_helper'

class EditPresenterTest < ActiveSupport::TestCase

  def presenter
    @_presenter ||= EditPresenter.new(edits(:one))
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test '#editor is presented' do
    assert_respond_to pres, :editor
    assert_respond_to pres.editor, :short_name
  end

  test '#changes' do
    assert_respond_to pres, :changes
  end

  test '#time_ago when applied' do
    item.applied_at = 10.hours.ago
    item.applied = true
    assert_equal 'about 10 hours ago', pres.time_ago
  end

  test '#time_ago when not applied' do
    expected = 'less than a minute ago'
    edit = Edit.new
    edit.save(validate: false)
    actual = EditPresenter.new(edit).time_ago
    assert_equal expected, actual
  end

  test '#time is an alias of #time_ago' do
    assert_equal pres.time_ago, pres.time
  end
end
