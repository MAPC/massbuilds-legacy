require 'test_helper'

class DeclineTest < ActiveSupport::TestCase
  def decline_service
    @_decline ||= Services::Edit::Decline.new(edit)
  end

  def edit
    @_edit ||= edits(:one)
  end

  test 'edit is valid' do
    assert edit.valid?
  end

  test '#perform! declines the edit' do
    decline_service.call
    assert_equal 'declined', edit.state
    assert edit.declined?
    assert edit.moderated_at
  end
end
