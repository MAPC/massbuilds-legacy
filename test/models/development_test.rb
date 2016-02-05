require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase
  def development
    @development ||= developments :one
  end

  alias_method :d, :development

  test 'valid' do
    assert d.valid?, d.errors.full_messages
  end

  test 'requires a creator' do
    d.creator = nil
    assert_not d.valid?
  end

  test 'requires a completion year' do
    d.year_compl = nil
    assert_not d.valid?
  end

  test 'can read attributes from fields, as methods' do
    assert_nothing_raised { d.name }
    assert_equal 'Godfrey Hotel', d.name
  end

  test 'raises NoMethodError when attribute not present' do
    assert_raises(NoMethodError) { d.blerg }
  end

  test 'attribute read is from an indifferent hash' do
    skip "Moving attributes out of hash."
    d.name = 'Godfrey Hotel'
    assert_equal d.fields['name'], d.name
    assert_equal d.fields[:name], d.name
  end

  test 'raises when attribute absent' do
    assert_raises(NoMethodError) {
      d.assign_attributes ov_hupipe_not: 10
    }
  end

  test 'literal attributes' do
    %i( affordable asofright cancelled clusteros commsf
        created_at crosswalks desc emploss estemp fa_edinst
        fa_hotel fa_indmf fa_ofcmd fa_other fa_ret fa_rnd fa_whs
        gqpop lgmultifam location mapc_notes onsitepark other_rate
        ovr55 phased private prjarea project_url rdv
        rptdemp singfamhu stalled status total_cost tothu
        twnhsmmult updated_at year_compl stories height
      ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test 'cached dynamic attributes' do
    %i( mixed_use ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  # Attributes

  test 'accepts 5-digit zip codes' do
    assert_respond_to d, :zip_code
    assert_respond_to d, :zip
    d.zip_code = '02139'
  end

  test 'accepts 9-digit zip codes' do
    d.zip_code = input = '02139-1112'
    assert d.save
    assert_equal '021391112',  d.read_attribute(:zip_code)
    assert_equal input, d.zip_code
  end

  # Associations

  test 'associations' do
    # #recent_changes -> presenter
    %i( contributors creator crosswalks edits flags history
        parcel team_members
        team_memberships walkscore programs
      ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test '#mixed_use?' do
    skip "Come back to this soon."
    assert_not Development.new.mixed_use?
    assert_not Development.new(tothu:  1).mixed_use?
    assert_not Development.new(commsf: 1).mixed_use?
    assert Development.new(tothu: 1, commsf: 1).mixed_use?
  end

  test '#edits' do
    d.edits = []
    assert_empty d.edits
    d.edits << Edit.new
    assert_not_empty d.edits
  end

  test '#history' do
    d.edits.new(applied: true).save(validate: false)
    assert_not_empty d.history
  end

  test '#pending' do
    assert_not_empty d.pending_edits
  end

  test '#contributors' do
    user = users :normal
    d.edits.new(editor: user, state: 'applied').save(validate: false)
    assert_includes d.contributors, user
  end

  test '#contributors pulls in unique users' do
    user = users :tim
    3.times {
      d.edits.new(editor: user, state: 'applied').save(validate: false)
    }
    d.creator = user
    assert_equal 1, d.contributors.count, d.contributors
  end

  test '#contributors does not include unapplied edits' do
    user = users :tim
    d.edits.new(editor: user, state: 'pending').save(validate: false)
    refute_includes d.contributors, user
  end

  test '#team_members' do
    org = organizations :mapc
    d.team_memberships.new(
      organization: org, role: :developer
    ).save(validate: false)
    assert_includes d.team_members, org
  end

  test '#crosswalks' do
    org = organizations :mapc
    d.crosswalks.new(organization: org, internal_id: "1-1")
    assert_not_empty d.crosswalks
  end

  test '#programs' do
    d.programs << programs(:massworks)
    d.programs << programs(:forty_b)
    assert_equal 2, d.programs.count
    assert_equal 1, d.incentive_programs.count
    assert_equal 1, d.regulatory_programs.count
  end

  test '#status' do
    [:projected, :planning, :in_construction, :completed].each do |status|
      d.status = status
      assert d.valid?
    end
    [:built, :solid, :dead, :stalled].each do |status|
      d.status = status
      assert_not d.valid?
    end
  end

  test 'status predicates' do
    [:projected?, :planning?, :in_construction?, :completed?].each { |method|
      assert_respond_to d, method
    }
  end

  test 'boolean predicates' do
    [:private?, :rdv?, :mixed_use?, :asofright?, :ovr55?,
      :clusteros?, :phased?, :stalled?].each do |method|
        assert_respond_to d, method
    end
  end


  test 'infer project type' do
    skip
  end

  test 'contributors includes creator' do
    creator = users(:normal)
    # TODO clear out edits on this development.
    assert d.creator.present?
    assert_includes d.contributors, creator
  end

  test 'applied edits result in contributors' do
    skip
  end

  test 'updates tagline' do
    d.update_attribute(:tagline, nil)
    d.save
    assert_not_nil d.tagline
  end

  test 'nearby developments' do
    far_dev = developments(:one)
    far_dev.latitude  =  40.000000
    far_dev.longitude = -77.000000
    far_dev.save

    close_dev = developments(:two)
    close_dev.latitude  =  39.010000
    close_dev.longitude = -75.990000
    close_dev.save

    close_devs = Development.close_to(39.000000, -76.000000).load

    assert_equal 1,         close_devs.size
    assert_equal close_dev, close_devs.first
  end

  test 'range scopes, dates' do
    range_scopes = %i( created_at updated_at )
    range_scopes.each { |scope| assert_respond_to Development, scope }
  end

  test 'range scopes, float and integer' do
    ranged_scopes.each { |scope| assert_respond_to Development, scope }
  end


  test 'boolean scopes' do
    boolean_scopes.each { |s| assert_respond_to Development, s }
  end

  test 'boolean scope definition' do
    assert_equal 1, Development.hidden(true).count
    assert_equal 1, Development.hidden.count
    assert_equal 3, Development.hidden(false).count
    assert_equal Development.hidden(true), Development.hidden
    refute_equal Development.hidden(true), Development.hidden(false)
  end

  # These tests and the params methods could stand some refactoring
  test 'periscope' do
    sql = Development.periscope(periscope_params).to_sql
    all_scopes.each { |scope| assert_includes sql, scope.to_s }
  end

  test 'periscope alt' do
    sql = Development.periscope(periscope_params_alt).to_sql
    all_scopes.each { |scope| assert_includes sql, scope.to_s }
  end

  def periscope_params
    hash = Hash.new
    ranged_scopes.each { |key| hash[key] = [0,1] }
    hash.merge({rdv: true, asofright: false, ovr55: nil, clusteros: 'true', phased: 'false', stalled: 'NULL', cancelled: true, hidden: true})
  end

  def periscope_params_alt
    hash = Hash.new
    ranged_scopes.each { |key| hash[key] = 1_234 }
    hash.merge({rdv: true, asofright: false, ovr55: nil, clusteros: 'true', phased: 'false', stalled: 'NULL', cancelled: true, hidden: true})
  end

  def ranged_scopes
    %i( height stories year_compl affordable
      prjarea singfamhu twnhsmmult lgmultifam tothu gqpop rptdemp
      emploss estemp commsf hotelrms onsitepark total_cost fa_ret
      fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst fa_other fa_hotel )
  end

  def boolean_scopes
    %i(rdv asofright ovr55 clusteros phased stalled cancelled hidden)
  end

  def all_scopes
    array = [ranged_scopes, boolean_scopes].flatten
    array.delete(:hidden) # Ignores hidden because of the alias, for now.
    array
  end

  test 'location' do
    assert_equal d.location, [71.000001,42.000001]
  end

end
