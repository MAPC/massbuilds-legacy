require 'test_helper'

class PeriscopeTest < ActiveSupport::TestCase

  def klass
    Development
  end

  test 'ranged_scopes' do
    assert_respond_to klass, :ranged_scopes
    assert_respond_to klass, :ranged_scope

    refute_respond_to klass, :attr_to_scope
    klass.ranged_scopes(:attr_to_scope)
    assert_respond_to klass, :attr_to_scope
    assert_nothing_raised { klass.periscope(attr_to_scope: [0, 100]) }
  end

  test 'boolean scopes' do
    assert_respond_to klass, :boolean_scopes
    assert_respond_to klass, :boolean_scope

    refute_respond_to klass, :bool_to_scope
    klass.boolean_scopes(:bool_to_scope)
    assert_respond_to klass, :bool_to_scope

    assert_equal true_sql,      klass.periscope(bool_to_scope: :true).to_sql
    assert_equal false_nil_sql, klass.periscope(bool_to_scope: 'false').to_sql
    assert_equal false_nil_sql, klass.periscope(bool_to_scope: :nil).to_sql
    assert_equal false_nil_sql, klass.periscope(bool_to_scope: nil).to_sql
  end

  private

  def true_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE \"developments\".\"bool_to_scope\" = 't'"
  end

  def false_nil_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE (\"developments\".\"bool_to_scope\" = 'f' OR \"developments\".\"bool_to_scope\" IS NULL)"
  end

end
