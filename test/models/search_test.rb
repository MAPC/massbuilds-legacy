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
    refute_empty search.results
  end

  test 'exact' do
    # Warning: Code Smell
    # Requires collaborator (Development) to have the right scopes
    assert_equal 1, search.results.count
    assert_equal developments(:one), search.results.first
  end

  test 'range' do
    ranged_search = searches(:ranged)
    assert_equal 1, ranged_search.results.count
  end

  test 'unsaved' do
    assert search.unsaved?
    refute  saved.unsaved?
  end

  test 'saved' do
    refute search.saved?
    assert  saved.saved?
  end

  test 'responds to #developments' do
    assert_respond_to search, :developments
  end

  test '#needs_update?' do
    development = developments(:one)
    Time.stub :now, Time.new(2010) do
      edit = development.pending_edits.first
      edit.applied
      edit.save
    end
    search.stub :developments, Development.all do
      assert search.updated_since?(Date.new(2000))
    end
  end

  test '#needs_update without history' do
    search.stub :developments, Development.new.history do
      refute search.updated_since?(Date.new(2000))
    end
  end

  test '#needs_update ignores updated_at' do
    development = developments(:one)
    Time.stub :now, Time.new(2010) do
      development.touch(:updated_at)
    end
    search.stub :developments, Development.new.history do
      refute search.updated_since?(Date.new(2000))
    end
  end

end
