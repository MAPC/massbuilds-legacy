require 'test_helper'

class EditTest < ActiveSupport::TestCase
  def edit
    @edit ||= edits :one
  end

  def development
    @development ||= developments :one
  end
  alias_method :project, :development

  test 'valid' do
    assert edit.valid?
  end

  test 'defaults to status :pending' do
    assert_equal 'pending', Edit.new.state
  end

  test 'requires a development' do
    edit.development = nil
    assert_not edit.valid?
  end

  test 'requires an editor (user)' do
    edit.editor = nil
    assert_not edit.valid?
  end

  test 'edited #fields' do
    assert_respond_to edit, :fields
  end

  test 'requires a state' do
    edit.state = nil
    assert_not edit.valid?
    edit.state = :blerg
    assert_not edit.valid?
  end

  focus
  test 'requires a log message' do
    edit.log_entry = ''
    assert_not edit.valid?
    edit.log_entry = 'a' * 24
    assert_not edit.valid?
    edit.log_entry = 'a' * 2001
    assert_not edit.valid?
    edit.log_entry = 'a' * 257
    assert edit.valid?
  end

  test 'state predicates' do
    [:pending?, :applied?].each { |method|
      assert_respond_to edit, method
    }
  end

  test '#conflict' do
    assert_empty edit.conflict
    edit.development.commsf = 13
    refute_empty edit.conflict
  end

  test '#conflict?' do
    refute edit.conflict?
    edit.development.commsf = 13
    assert edit.conflict?
  end

  test '#applyable' do
    assert edit.applyable?, [edit.inspect, edit.conflict?]
  end

  test 'approved' do
    assert_respond_to edit, :approved
    refute edit.moderated_at
    edit.approved
    assert_equal 'approved', edit.state
    # assert_equal 'approved', edit.reload.state
    assert edit.moderated_at
  end

  test 'declined' do
    assert_respond_to edit, :declined
    refute edit.moderated_at
    edit.declined
    assert_equal 'declined', edit.state
    # assert_equal 'declined', edit.reload.state
    assert edit.moderated_at
  end

  test 'moderated' do
    refute edit.moderated?
    edit.declined
    assert edit.moderated?
  end

  test 'moderatable?' do
    assert edit.moderatable?, edit.inspect
    edit.declined
    refute edit.moderatable?
  end

end
