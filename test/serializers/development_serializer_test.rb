require 'test_helper'

class DevelopmentSerializerTest < ActiveSupport::TestCase

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

  def serializer
    @_base ||= DevelopmentSerializer.new(nil)
  end

  def serializer_with_development
    @_development ||= DevelopmentSerializer.new(development, max_team_size: 1)
  end

  def serializer_only
    @_only ||= DevelopmentSerializer.new(development, only: 'name')
  end

  def serializer_except
    @_e ||= DevelopmentSerializer.new(development, except: [:name, 'address'])
  end

  alias_method :base,   :serializer
  alias_method :dev,    :serializer_with_development
  alias_method :only,   :serializer_only
  alias_method :except, :serializer_except

  test '#to_row' do
    assert_respond_to base, :to_row
  end

  test '#to_row produces csv row of values' do
    Time.stub :now, Time.at(0) do
      actual_row = dev.to_row
      expected_row.each_with_index do |expected_value, index|
        # Cast to string to avoid annoying value issues
        assert_equal expected_value.to_s, actual_row[index].to_s
      end
    end
  end

  test '#to_row includes development team' do
    assert_includes dev.to_row, 'landlord'
  end

  test '#to_header with an #attribute-less object' do
    assert_respond_to base, :to_header
    assert_equal [], base.to_header
  end

  test '#to_header with an object' do
    assert_equal expected_header, dev.to_header,
      """
        Extra value in actual header: #{e = (dev.to_header - expected_header).first}
        At index: #{dev.to_header.index(e)}
      """
  end

  test '#to_header shows development team' do
    assert_includes dev.to_header, 'team_member_1_name'
    assert_includes dev.to_header, 'team_member_1_role'
  end

  test 'can allow (only) certain attributes' do
    refute_includes ['505 Washington Street'], only.to_row
    refute_includes ['address'], only.to_header
  end

  test 'can block (except) attributes' do
    refute_includes except.to_row, 'Godfrey Hotel'
    refute_includes except.to_row, '505 Washington Street'
    refute_includes except.to_header, 'name'
  end

  private

  def expected_row
    csv.to_a[1]
  end

  def expected_header
    csv.headers
  end

  def csv
    CSV.parse(csv_file, headers: true)
  end

  def csv_file
    File.read 'test/fixtures/csvs/serializer_test.csv'
  end

end
