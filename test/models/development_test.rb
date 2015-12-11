require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase
  def development
    @development ||= developments :one
  end

  alias_method :d, :development

  test "valid" do
    assert d.valid?
  end

  test "can read attributes from fields, as methods" do
    assert_nothing_raised { d.name }
    assert_equal 'Godfrey Hotel', d.name
  end

  test "raises NoMethodError when attribute not present" do
    assert_raises(NoMethodError) { d.blerg }
  end

  test "attribute read is from an indifferent hash" do
    d.name = 'Godfrey Hotel'
    assert_equal d.fields['name'], d.name
    assert_equal d.fields[:name], d.name
  end

  test "raises when attribute absent" do
    assert_raises(NoMethodError) {
      d.assign_attributes ov_hupipe_not: 10
    }
  end

  test "literal attributes" do
    %i( affordable affunits asofright cancelled clusteros commsf
        created_at crosswalks desc emploss estemp fa_edinst
        fa_hotel fa_indmf fa_ofcmd fa_other fa_ret fa_rnd fa_whs
        gqpop lgmultifam location mapc_notes onsitepark othremprat
        ovr55 phased private prjarea project_type project_url rdv
        rptdemp singfamhu stalled status total_cost tothu
        twnhsmmult updated_at year_compl
      ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test "cached dynamic attributes" do
    %i( mixed_use ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test "associations" do
    # #recent_changes -> presenter
    %i( contributors creator crosswalks edits flags history
        last_edit parcel team_members
        team_memberships walkscore zoning_tools
      ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test "#mixed_use?" do
    assert_not Development.new.mixed_use?
    assert_not Development.new(tothu:  1).mixed_use?
    assert_not Development.new(commsf: 1).mixed_use?
    assert Development.new(tothu: 1, commsf: 1).mixed_use?
  end

  test "#edits" do
    d.edits = []
    assert_empty d.edits
    d.edits << Edit.new
    assert_not_empty d.edits
  end

  test "#history" do
    d.edits.new(state: 'applied').save(validate: false)
    assert_not_empty d.history
  end

  test "#last_edit" do
    3.times {
      d.edits.new(state: 'applied', applied_at: 1.minute.ago).save(validate: false)
    }
    last_edit = d.edits.new(state: 'applied', applied_at: Time.now)
    last_edit.save(validate: false)
    assert_equal last_edit, d.last_edit
  end

end

















