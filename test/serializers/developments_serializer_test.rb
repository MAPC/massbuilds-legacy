require 'test_helper'

class DevelopmentsSerializerTest < ActiveSupport::TestCase

  def development
    @_d = developments :one
    @_d.team_memberships = [
      DevelopmentTeamMembership.create(
        development:  @_d,
        role:        'landlord',
        organization: organizations(:mapc)
      )
    ]
    @_d
  end

  def development_two
    @_d = developments :two
  end

  def serializer
    @_base ||= DevelopmentsSerializer.new([development, development_two])
  end
  alias_method :base, :serializer

  test '#developments' do
    refute_empty base.developments
  end

  test 'prevents empty developments' do
    assert_raises(ArgumentError) { DevelopmentsSerializer.new([]) }
  end

  test '#to_header' do
    assert_equal 1, development.team_memberships.count
    assert_equal 1, development.team_members.count
    assert_equal expected_header, base.to_header
  end

  test '#to_csv' do
    assert_respond_to base, :to_csv
    Time.stub :now, Time.at(0) do
      assert_equal expected_csv.to_s, base.to_csv
    end
  end

  private

  def expected_header
    expected_csv.headers
  end

  def expected_csv
    CSV.parse(csv_file, headers: true)
  end

  def csv_file
    File.read 'test/fixtures/csvs/developments_serializer.csv'
  end

end
