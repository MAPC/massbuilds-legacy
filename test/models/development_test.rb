require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase

  include ExternalServices::Fakes

  def development
    @development ||= developments :one
    mock_out @development
  end

  def new_development(*args)
    mock_out Development.new(*args)
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

  test 'literal attributes' do
    # Could move this into the i18n settings / locales
    %i( affordable asofright cancelled clusteros commsf
        created_at desc emploss estemp fa_edinst
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
    assert d.valid?
  end

  test 'accepts 9-digit zip codes' do
    d.zip_code = input = '02139-1112'
    assert d.valid?
    d.save!
    assert_equal '021391112', d.read_attribute(:zip_code)
    assert_equal input, d.zip_code
  end

  # Associations

  test 'associations' do
    # #recent_changes -> presenter
    %i(
        contributors creator edits editors flags history parcel team_members
        team_memberships walkscore programs
      ).each do |attribute|
      assert_respond_to d, attribute
    end
  end

  test '#mixed_use? responds to attributes' do
    assert_respond_to new_development, :mixed_use?
    assert_respond_to new_development, :mixed_use
    refute new_development.mixed_use?
    refute new_development(tothu:  1).mixed_use?
    refute new_development(commsf: 1).mixed_use?
    assert new_development(tothu: 1, commsf: 1).mixed_use?
  end

  test '#mixed_use? prioritizes changed values over persisted values' do
    dev = new_development(tothu: 1, commsf: 1)
    assert dev.mixed_use?
    dev.save! validate: false
    assert dev.mixed_use?
    dev.tothu = 0
    refute dev.mixed_use?
  end

  test '#history is a collection of applied edits' do
    d.edits.new(applied: true).save(validate: false)
    assert_not_empty d.history
  end

  test '#pending' do
    # These are set up in the fixtures.
    assert_not_empty d.edits.pending
  end

  test '#contributors contains the creator' do
    assert_includes d.contributors, d.creator
  end

  test '#contributors is a collection of unique users with applied edits' do
    user = users :tim
    refute_includes d.contributors, user # Is not the creator.
    3.times {
      d.edits.new(editor: user, state: 'applied').save(validate: false)
    }
    # Appears only once in the contributors list
    assert_equal 1, d.contributors.count, d.contributors
  end

  test '#contributors excludes unapplied edits' do
    user = users :tim
    [:approved, :declined, :pending].each do |status|
      d.edits.new(editor: user, state: status).save(validate: false)
    end
    refute_includes d.contributors, user
  end

  test '#team_members' do
    org = organizations :mapc
    d.team_memberships.new(
      organization: org,
      role: :developer
    ).save(validate: false)
    assert_includes d.team_members, org
  end

  test '#crosswalks' do
    skip 'not yet implemented'
    org = organizations :mapc
    d.crosswalks.new(organization: org, internal_id: '1-1')
    assert_not_empty d.crosswalks
  end

  test '#programs' do
    skip 're-implement this with Enumerize'
    d.programs << programs(:massworks)
    d.programs << programs(:forty_b)
    assert_equal 2, d.programs.count
    assert_equal 1, d.programs.incentive.count
    assert_equal 1, d.programs.regulatory.count
  end

  test '#status' do
    d.tothu = d.commsf = 0 # Prevent additional info validation
    [:projected, :planning, :in_construction, :completed].each do |status|
      d.status = status
      assert d.valid?, d.errors.full_messages
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

  test 'contributors includes creator' do
    creator = users(:normal)
    # TODO: clear out edits on this development.
    assert d.creator.present?
    assert_includes d.contributors, creator
  end

  test 'if tagline, needs to be short' do
    d.tagline = ''
    assert d.valid?, d.errors.full_messages

    invalid_taglines = [
      'Invalid.',
      "Value capture compatible uses gridiron modernist tradition facilitate
       easement street parking storefront state funding vacancy developed world
       topography disadvantaged unincorporated community Le Corbusier
       geospatial analysis."
    ]
    invalid_taglines.each do |tagline|
      d.tagline = tagline
      refute d.valid?, "Is length #{tagline.length}"
    end
  end

  test 'nearby developments' do
    far_dev = mock_out(developments(:one))
    far_dev.latitude  =  40.000000
    far_dev.longitude = -77.000000
    far_dev.save!

    close_dev = mock_out(developments(:two))
    close_dev.latitude  =  39.010000
    close_dev.longitude = -75.990000
    close_dev.save!

    close_devs = Development.close_to(39.000000, -76.000000).load

    assert_equal 1,         close_devs.size
    assert_equal close_dev, close_devs.first
  end

  test 'location' do
    assert_equal [42.000001, 71.000001], d.location
    assert_equal [71.000001, 42.000001], d.rlocation
  end

  test '#subscriptions' do
    refute_empty d.subscriptions
  end

  test '#subscribers' do
    refute_empty d.subscribers
    assert_includes d.subscribers, users(:normal)
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
    skip
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

  test '#updated_since?' do
    Time.stub :now, Time.new(2001) do
      edit = d.edits.pending.first
      edit.applied
      edit.save
    end
    assert d.updated_since?(Date.new(2000))
  end

  test '#updated_since? without history' do
    refute d.updated_since?(Date.new(2000))
  end

  test '#history.since' do
    edit = d.edits.pending.first
    Time.stub :now, Time.new(2000, 1, 2) do
      edit.applied
      edit.save
    end
    assert_equal [edit], d.history.since(Time.new(2000, 1, 1))
  end

  test '#history.since without history' do
    assert_equal [], d.history.since(Time.new(2000, 1, 2))
  end

  test '#place' do
    assert_respond_to d, :place
    city = places(:boston)
    d.place = city
    assert d.place
    assert_equal d.city, d.place
  end

  test '#municipality if assigned a municipality' do
    assert_respond_to d, :municipality
    muni = places(:boston)
    d.place = muni
    assert_equal muni, d.municipality
  end

  test '#municipality if assigned a neighborhood' do
    hood = places(:back_bay)
    d.place = hood
    assert_equal hood.municipality, d.municipality
  end

  test '#neighborhood if assigned a neighborhood' do
    assert_respond_to d, :neighborhood
    hood = places(:back_bay)
    d.place = hood
    assert_equal hood, d.neighborhood
  end

  test '#neighborhood if assigned a municipality' do
    muni = places(:boston)
    d.place = muni
    assert_equal nil, d.neighborhood
  end

  test 'column bounds' do
    expected = column_bound_keys
    actual = Development.ranged_column_bounds.keys
    assert_equal expected, actual
  end

  def column_bound_keys
    [:created_at, :updated_at, :height, :stories, :year_compl, :prjarea,
     :singfamhu, :twnhsmmult, :lgmultifam, :tothu, :gqpop, :rptdemp,
     :emploss, :estemp, :commsf, :hotelrms, :onsitepark, :total_cost,
     :team_membership_count, :fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs,
     :fa_rnd, :fa_edinst, :fa_other, :fa_hotel, :other_rate, :affordable,
     :latitude, :longitude]
  end

  def periscope_params
    hash = Hash.new
    ranged_scopes.each { |key| hash[key] = [0,1] }
    hash.merge(mergeable_hash)
  end

  def periscope_params_alt
    hash = Hash.new
    ranged_scopes.each { |key| hash[key] = 1_234 }
    hash.merge(mergeable_hash)
  end

  def mergeable_hash
    { rdv:   true, asofright: false,  phased:  'false', cancelled: true,
      ovr55: nil,  clusteros: 'true', stalled: 'NULL',  hidden: true }
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

  test 'street view' do
    skip 'extract this'
    assert_respond_to development, :street_view
    assert_respond_to development.street_view, :url
    assert_respond_to development.street_view, :image
  end

  test 'cache street view' do
    skip 'should go elsewhere'
    assert_difference 'development.street_view_image.size', 21904 do
      development.update_attributes street_view_attrs
    end
  end

  def street_view_attrs
    { street_view_heading: 0, street_view_pitch: 11 }
  end

  test 'cache walk score' do
    skip 'extract this or simplify it'
    assert_respond_to development, :walkscore
    attrs = { 'id' => nil, street_view_heading: 0, street_view_pitch: 11 }
    dev = new_development(d.attributes.merge(attrs))
    assert_empty dev.walkscore
    dev.save!
    assert_equal 98, dev.walkscore.score
    assert_equal "Walker's Paradise", dev.walkscore.to_h['description']
  end

  test 'associate place' do
    place = places(:boston)
    d.place = nil
    Place.stub :contains, [place] do
      d.update_attribute(:latitude, 0.00)
    end
    assert_equal place, d.place
  end

  test 'associate no place' do
    d.place = nil
    Place.stub :contains, [] do
      d.update_attribute(:latitude, 0.00)
    end
    assert_equal nil, d.place
  end

  test 'estimates employment' do
    skip 'this an external service does this'
    d.estemp = nil
    d.commsf = d.fa_ret = 0
    d.save!
    assert_equal 0, d.estemp
    d.commsf = d.fa_ret = 750
    d.save!
    assert d.estemp > 0
  end

  test 'out of date' do
    development.created_at = 7.months.ago
    development.updated_at = 7.months.ago
    assert development.out_of_date?

    opts = {
      applied:      true,
      applied_at:   Time.now,
      editor:       users(:normal),
      state:        :approved,
      moderated_at: Time.now
    }
    development.edits.create!(opts)
    refute development.out_of_date?
  end

  test 'requires housing units and commercial square feet' do
    d.tothu = d.commsf = nil
    refute d.valid?
    d.tothu = d.commsf = 0
    assert d.valid?, d.errors.full_messages
  end

  test 'requires extra housing information' do
    # If it's in construction or completed, and there's more than
    # one housing unit, require extra housing information.
    housing_fields = Development::HOUSING_FIELDS

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu  = 1
      d.commsf = 0
      housing_fields.each { |attrib| d.send("#{attrib}=", nil) }
      refute d.valid?
      housing_fields.each { |attrib| d.send("#{attrib}=", 0) }
      d.singfamhu = 1 # for sum validation
      assert d.valid?, d.errors.full_messages
    end

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu = d.commsf = 0
      housing_fields.each { |attrib| d.send("#{attrib}=", nil) }
      assert d.valid?, d.errors.full_messages
    end
  end

  test 'requires extra nonres information if in_construction or completed' do
    nonres_fields = Development::COMMERCIAL_FIELDS

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu  = 0
      d.commsf = 1
      nonres_fields.each { |attrib| d.send("#{attrib}=", nil) }
      refute d.valid?
      nonres_fields.each { |attrib| d.send("#{attrib}=", 0) }
      d.fa_ret = 1 # For sum validation
      assert d.valid?, d.errors.full_messages
    end

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu = d.commsf = 0
      nonres_fields.each { |attrib| d.send("#{attrib}=", nil) }
      assert d.valid?, d.errors.full_messages
    end
  end

  test 'housing units must add up' do
    d.status = :in_construction
    d.tothu  = 100
    d.commsf = d.gqpop = 0
    d.singfamhu = d.twnhsmmult = d.lgmultifam = 0
    refute d.valid?
    d.singfamhu = 100
    assert d.valid?, d.errors.full_messages
    d.singfamhu = d.twnhsmmult = 25
    d.lgmultifam = 50
    assert d.valid?, d.errors.full_messages
  end

  test 'commercial square feet must add up' do
    d.status = :in_construction
    d.tothu = 0
    d.commsf = 1000

    d.fa_ret    = 0
    d.fa_ofcmd  = 0
    d.fa_indmf  = 0
    d.fa_whs    = 0
    d.fa_rnd    = 0
    d.fa_edinst = 0
    d.fa_other  = 0
    d.fa_hotel  = 0

    refute d.valid?
    d.fa_ret = 1000
    assert d.valid?, d.errors.full_messages
    d.fa_ret = d.fa_ofcmd = d.fa_hotel = d.fa_other = 250
    assert d.valid?, d.errors.full_messages
  end

  test 'nearest transit station' do
    skip 'this is an external service'
    d.latitude_will_change! # This prompts an update.
    d.save
    assert_respond_to d, :nearest_transit
    assert_equal d.nearest_transit, 'Boylston'
  end

  test 'infer project type' do
    skip 'not doing'
  end

  test 'applied edits result in contributors' do
    skip "there's already a test for this, and it's not good"
  end

  test 'description' do
    skip
  end

end
