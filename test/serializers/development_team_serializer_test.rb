require 'test_helper'

class DevelopmentTeamSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= DevelopmentTeamSerializer.new(developments(:one), 1)
  end

  def nine_team_members
    @_niner ||= DevelopmentTeamSerializer.new(developments(:one), 9)
  end
  alias_method :base,  :serializer
  alias_method :niner, :nine_team_members

  test '#to_header' do
    assert_equal header, base.to_header
  end

  test '#to_header with more projects' do
    header = niner.to_header
    assert_equal 63, header.count
    assert_equal 'team_member_1_name', header.first
    assert_equal 'team_member_9_role', header.last
  end

  test '#to_row' do
    assert_equal row, base.to_row
  end

  test '#to_row with more projects' do
    row = niner.to_row
    assert_equal 63,  row.count
    assert_equal 6,   row.compact.count # there are 2 nil values
    assert_equal      row.first, row.first
    assert_equal nil, row.last
  end

  private

  def header
    # Not clear why it's picking up extra nils.
    csv.headers.compact
  end

  def row
    csv.to_a[1]
  end

  def csv
    file = File.open('test/fixtures/csvs/team.csv')
    CSV.parse(file, headers: true)
  end

end
