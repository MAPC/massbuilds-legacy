require 'test_helper'

class PeriscopeTest < ActiveSupport::TestCase

  def klass
    Development
  end

  # Sometimes it's two failures, sometimes 3. Is that because of the order?
  # I think it's because of the order. Clear out every time in setup.

  test 'test responds to ranged scopes' do
    assert_respond_to klass, :ranged_scopes
    assert_respond_to klass, :ranged_scope

    refute_respond_to klass, :attr_to_scope
    klass.ranged_scopes(:attr_to_scope)
    assert_respond_to klass, :attr_to_scope
    assert_nothing_raised { klass.periscope(attr_to_scope: [0, 100]) }
  end

  test 'responds to boolean scopes' do
    assert_respond_to klass, :boolean_scopes
    assert_respond_to klass, :boolean_scope

    refute_respond_to klass, :bool_to_scope
    klass.boolean_scopes(:bool_to_scope)
    assert_respond_to klass, :bool_to_scope

    assert_equal true_sql,  klass.periscope(bool_to_scope: :true).to_sql
    assert_equal false_sql, klass.periscope(bool_to_scope: 'false').to_sql
    # assert_equal nil_sql,   klass.periscope(bool_to_scope: nil).to_sql

    assert_equal false_sql, klass.periscope(bool_to_scope: :false).to_sql
  end


  # Test using an implementer class -- doesn't need to be nor should
  #   it be development -- but Implementer < ActiveRecord::Base

  # test 'range scopes, dates' do
  #   range_scopes = %i( created_at updated_at )
  #   range_scopes.each { |scope| assert_respond_to Development, scope }
  # end

  # test 'range scopes, float and integer' do
  #   ranged_scopes.each { |scope| assert_respond_to Development, scope }
  # end

  # test 'boolean scopes' do
  #   skip 'not a useful test'
  #   boolean_scopes.each { |s| assert_respond_to Development, s }
  # end

  # test 'boolean scope definition' do
  #   assert_equal 1, Development.hidden(true).count
  #   assert_equal 1, Development.hidden.count
  #   assert_equal 3, Development.hidden(false).count
  #   assert_equal Development.hidden(true), Development.hidden
  #   refute_equal Development.hidden(true), Development.hidden(false)
  # end

  # # These tests and the params methods could stand some refactoring
  # test 'periscope' do
  #   sql = Development.periscope(periscope_params).to_sql
  #   all_scopes.each { |scope| assert_includes sql, scope.to_s }
  # end

  # test 'periscope alt' do
  #   sql = Development.periscope(periscope_params_alt).to_sql
  #   all_scopes.each { |scope| assert_includes sql, scope.to_s }
  # end

  # def periscope_params
  #   hash = Hash.new
  #   ranged_scopes.each { |key| hash[key] = [0,1] }
  #   hash.merge(mergeable_hash)
  # end

  # def periscope_params_alt
  #   hash = Hash.new
  #   ranged_scopes.each { |key| hash[key] = 1_234 }
  #   hash.merge(mergeable_hash)
  # end

  # def mergeable_hash
  #   { rdv:   true, asofright: false,  phased:  'false', cancelled: true,
  #     ovr55: nil,  clusteros: 'true', stalled: 'NULL',  hidden: true }
  # end

  # def ranged_scopes
  #   %i( height stories year_compl affordable
  #     prjarea singfamhu twnhsmmult lgmultifam tothu gqpop rptdemp
  #     emploss estemp commsf hotelrms onsitepark total_cost fa_ret
  #     fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst fa_other fa_hotel )
  # end

  # def boolean_scopes
  #   %i(rdv asofright ovr55 clusteros phased stalled cancelled hidden)
  # end

  # def all_scopes
  #   array = [ranged_scopes, boolean_scopes].flatten
  #   array.delete(:hidden) # Ignores hidden because of the alias, for now.
  #   array
  # end

  private

  def true_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE \"developments\".\"bool_to_scope\" = 't'"
  end

  def false_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE \"developments\".\"bool_to_scope\" = 'f'"
  end

  def false_nil_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE (\"developments\".\"bool_to_scope\" = 'f' OR \"developments\".\"bool_to_scope\" IS NULL)"
  end

  def nil_sql
    "SELECT \"developments\".* FROM \"developments\" WHERE \"developments\".\"bool_to_scope\" IS NULL"
  end

end

