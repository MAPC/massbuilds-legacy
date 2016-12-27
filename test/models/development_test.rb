require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase

  include ExternalServices::Fakes
  # TODO include DevelopmentTests::ValidationTest

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

  test 'description' do
    d.description = ''
    assert d.valid?

    d.description = 'too short'
    refute d.valid?

    d.description = 'This is a property with some information about things.'
    assert d.valid?
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
    d.team_memberships.new(organization: org, role: :developer).
      save(validate: false)
    assert_includes d.team_members, org
  end

  test '#programs' do
    d.programs = ["40B", "MassWorks Infrastructure Program"]
    assert_equal 2, d.programs.count
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

  test 'responds to place-related methods' do
    assert_respond_to d, :place
    assert_respond_to d, :municipality
    assert_respond_to d, :neighborhood
  end

  test 'neighborhood and city' do
    d.place = nil
    refute d.place
    d.place = places(:roxbury)
    assert d.place
    assert_equal d.city, d.place.municipality
    assert_equal d.neighborhood, d.place
  end

  test 'street view' do
    assert_respond_to development, :street_view
  end

  test 'cache walk score' do
    d.update_attribute :walkscore, {}
    assert_empty d.walkscore
    d.latitude_will_change!
    d.save!
    assert_not_empty d.walkscore
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
    d.estemp = nil
    d.save!
    assert_not_nil d.estemp
  end

  test 'out of date' do
    development.created_at = 7.months.ago
    development.updated_at = 7.months.ago
    assert development.out_of_date?

    create_recent_edit(development)
    refute development.out_of_date?
  end

  def create_recent_edit(development)
    opts = {
      applied:      true,
      applied_at:   Time.now,
      editor:       users(:normal),
      state:        :approved,
      moderated_at: Time.now
    }
    development.edits.create!(opts)
  end

  test 'nearest transit station' do
    assert_respond_to d, :nearest_transit
    assert_nil d.nearest_transit
    d.latitude_will_change! # Mark latitude as changing to prompt an update.
    d.save!(validate: false)
    assert d.nearest_transit.is_a?(String)
  end

  # Crosswalks
  # test '#crosswalks' do
  #   org = organizations :mapc
  #   d.crosswalks.new(organization: org, internal_id: '1-1')
  #   assert_not_empty d.crosswalks
  # end


end
