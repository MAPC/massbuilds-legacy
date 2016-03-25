require 'test_helper'

class PeriscopeTest < ActiveSupport::TestCase

  def klass
    Development
  end

  test 'ranged_scopes' do
    assert_respond_to klass, :ranged_scopes
    assert_respond_to klass, :ranged_scope

    refute_respond_to klass, :attr_to_scope
    Development.ranged_scopes(:attr_to_scope)
    assert_respond_to klass, :attr_to_scope
    assert_nothing_raised { klass.periscope(attr_to_scope: [0, 100]) }
  end

  test 'boolean scopes' do
    assert_respond_to klass, :boolean_scopes
    assert_respond_to klass, :boolean_scope

    refute_respond_to klass, :bool_to_scope
    Development.boolean_scopes(:bool_to_scope)
    assert_respond_to klass, :bool_to_scope
  end

end
