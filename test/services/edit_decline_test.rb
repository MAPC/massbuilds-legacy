require 'test_helper'

class EditDeclineTest < ActiveSupport::TestCase
  def decline
    @_decline ||= EditDecline.new(edits(:one))
  end

  def edit
    decline.edit
  end

  def development
    decline.edit.development
  end

  test 'precondition: edit is valid' do
    assert edit.valid?
  end

  test '#perform! declines the edit' do
    decline.perform!
    assert_equal 'declined', edit.state
    assert edit.declined?
    assert edit.moderated_at
  end
end
