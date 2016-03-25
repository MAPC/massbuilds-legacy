require 'test_helper'
require 'range_parser'

class RangeParserTest < ActiveSupport::TestCase

  test 'parses array' do
    assert_equal (1..3), RangeParser.parse([1,3])
    assert_equal (0.1..0.33), RangeParser.parse([0.1,0.33])
  end

  test 'parses array of strings' do
    assert_equal (1..3), RangeParser.parse(['1', '3'])
    assert_equal (0.1..0.33), RangeParser.parse(['0.1', '0.33'])
  end

  test 'parses string of array' do
    assert_equal (1..3), RangeParser.parse('[1,3]')
    assert_equal (11..13), RangeParser.parse('[11,13]')
    assert_equal (0.1..0.33), RangeParser.parse('[0.1,0.33]')
  end

  test 'parses string of array with space' do
    assert_equal (1..3), RangeParser.parse('[1, 3]')
    assert_equal (0.1..0.33), RangeParser.parse('[0.1, 0.33]')
  end

  test 'parses comma-separated string' do
    assert_equal (1..3), RangeParser.parse('1,3')
    assert_equal (0.1..0.33), RangeParser.parse('0.1,0.33')
  end

  test 'parses comma-separated string with spaces' do
    assert_equal (1..3), RangeParser.parse('1    ,        3')
    assert_equal (0.1..0.33), RangeParser.parse('0.1   ,   0.33')
  end

  test 'parses confused format from JSONAPI' do
    value = ["[11", "13]"]
    assert_equal (11..13), RangeParser.parse(value)
  end

  test 'parses string of array of strings' do
    assert_nothing_raised { RangeParser.parse('["1", "3"]') }
    assert_equal (1..3), RangeParser.parse("['1', '3']")
    assert_equal (1..3), RangeParser.parse('["1", "3"]')
    assert_equal (0.1..0.33), RangeParser.parse('["0.1", "0.33"]')
  end

  test 'parses empty string' do
    ['', nil, []].each { |e|
      assert_equal infinity, RangeParser.parse(e)
    }
  end

  def infinity
    (-Float::INFINITY..Float::INFINITY)
  end

end
