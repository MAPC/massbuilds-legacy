require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase
  def development
    @development ||= developments :one
  end

  alias_method :d, :development

  test "valid" do
    assert d.valid?, d.errors.full_messages
  end

  test "requires a creator" do
    d.creator = nil
    assert_not d.valid?
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
        gqpop lgmultifam location mapc_notes onsitepark other_rate
        ovr55 phased private prjarea project_type project_url rdv
        rptdemp singfamhu stalled status total_cost tothu
        twnhsmmult updated_at year_compl stories feet_tall
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
        team_memberships walkscore programs
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

  test "#pending" do
    assert_not_empty d.pending_edits
  end

  test "#last_edit" do
    3.times {
      d.edits.new(state: 'applied', applied_at: 1.minute.ago).save(validate: false)
    }
    last_edit = d.edits.new(state: 'applied', applied_at: Time.now)
    last_edit.save(validate: false)
    assert_equal last_edit, d.last_edit
  end

  test "#contributors" do
    user = users :normal
    d.edits.new(editor: user, state: 'applied').save(validate: false)
    assert_includes d.contributors, user
  end

  test "#contributors pulls in unique users" do
    user = users :tim
    3.times {
      d.edits.new(editor: user, state: 'applied').save(validate: false)
    }
    d.creator = user
    assert_equal 1, d.contributors.count, d.contributors
  end

  test "#contributors does not include unapplied edits" do
    user = users :tim
    d.edits.new(editor: user, state: 'pending').save(validate: false)
    refute_includes d.contributors, user
  end

  test "#team_members" do
    org = organizations :mapc
    d.team_memberships.new(
      organization: org, role: :developer
    ).save(validate: false)
    assert_includes d.team_members, org
  end

  test "#crosswalks" do
    org = organizations :mapc
    d.crosswalks.new(organization: org, internal_id: "1-1")
    assert_not_empty d.crosswalks
  end

  test "#programs" do
    d.programs << programs(:massworks)
    d.programs << programs(:forty_b)
    assert_equal 2, d.programs.count
    assert_equal 1, d.incentive_programs.count
    assert_equal 1, d.regulatory_programs.count
  end

  test "#status" do
    [:projected, :planning, :in_construction, :completed].each do |status|
      d.status = status
      assert d.valid?
    end
    [:built, :solid, :dead, :stalled].each do |status|
      d.status = status
      assert_not d.valid?
    end
  end

  test "status predicates" do
    [:projected?, :planning?, :in_construction?, :completed?].each {|method|
      assert_respond_to d, method
    }
  end

  test "boolean predicates" do
    [:private?, :rdv?, :mixed_use?, :asofright?, :ovr55?,
      :clusteros?, :phased?, :stalled?].each do |method|
        assert_respond_to d, method
    end
  end

  test "infer project type" do
    skip
  end

  test "apply edit" do
    d.edits = []
    d.commsf = 12
    edit = edits(:one)
    d.edits << edit
    assert_equal 12, d.commsf
    assert_not edit.conflict?, edit.conflict
    assert_difference 'd.history.count', +1 do
      edit.apply!
    end
    assert_equal 'applied', edit.state
    assert_equal 1000, d.commsf
  end

  test "contributors includes creator" do
    creator = users(:normal)
    # TODO clear out edits on this development.
    assert d.creator.present?
    assert_includes d.contributors, creator
  end

  test "applied edits result in contributors" do
    skip
  end

  test "updates tagline" do
    d.update_attribute(:tagline, nil)
    d.save
    assert_not_nil d.tagline
  end

  test "metadata" do
    assert_respond_to Development, :fields_hash
    dfh = Development.fields_hash
    assert_equal 'status', dfh['status'].name
    assert_equal 'Project area', dfh['prjarea'].human_name
  end

  test "field categories" do
    cats = %w( boolean commercial residential miscellaneous )
    cats.each {|cat|
      assert_includes Development.field_categories, cat
    }
  end

  test "field category helper methods" do
    %w( boolean commercial residential miscellaneous ).each {|cat|
      assert_respond_to Development, :"#{cat}_fields"
    }
    assert_includes Development.boolean_fields, 'clusteros'
    refute_includes Development.commercial_fields, 'clusteros'
  end

  test "gets metatdata for fields" do
    assert_equal d.name_for(:status), 'status'
    assert_equal d.human_name_for('prjarea'), 'Project area'
    assert_equal d.description_for(:prjarea), "Area of development site, in square feet"
    assert_equal d.category_for(:year_compl), 'miscellaneous'
  end

end
