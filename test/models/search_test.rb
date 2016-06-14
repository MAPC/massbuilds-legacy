require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  def search
    @_search ||= searches(:exact)
  end

  def saved_search
    @_saved_search ||= searches(:saved)
  end

  alias_method :saved, :saved_search

  test 'valid' do
    assert search.valid?
  end

  test 'requires a current_user' do
    search.user = nil
    assert_not search.valid?
  end

  test 'query' do
    refute_empty search.query
    assert_instance_of Hash, search.query
  end

  test 'results' do
    refute_empty search.results, search.inspect
  end

  test 'exact' do
    # Warning: Code Smell
    # Requires collaborator (Development) to have the right scopes
    assert_equal 1, search.results.count
    assert_equal developments(:stable_one).id, search.results.first.id
  end

  test 'range' do
    ranged_search = searches(:ranged)
    assert_equal 1, ranged_search.results.count
  end

  test 'responds to #developments' do
    assert_respond_to search, :developments
  end

  test '#updated_since?' do
    development = developments(:one)
    Time.stub :now, Time.new(2010) do
      edit = development.edits.pending.first
      edit.applied
      edit.save
    end
    search.stub :developments, Development.all do
      assert search.updated_since?(Date.new(2000))
    end
  end

  test '#updated_since? without history' do
    search.stub :developments, Development.new.history do
      refute search.updated_since?(Date.new(2000))
    end
  end

  test '#updated_since? ignores updated_at' do
    development = developments(:one)
    Time.stub :now, Time.new(2010) do
      development.touch(:updated_at)
    end
    search.stub :developments, Development.new.history do
      refute search.updated_since?(Date.new(2000))
    end
  end

  test '#unsaved?' do
    assert search.unsaved?
    refute saved.unsaved?
  end

  test '#saved?' do
    refute search.saved?
    assert saved.saved?
  end

  test 'autogenerates a title if saved:true' do
    refute search.title.presence
    search.saved = true
    search.save
    assert search.title.presence
  end

  test 'does not autogen a title if saved:false' do
    refute search.title.presence
    search.saved = false
    search.save
    refute search.title.presence
  end

end
