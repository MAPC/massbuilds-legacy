require 'test_helper'
require 'range_parser'

class RangeParserTest < ActiveSupport::TestCase

  test "parses array" do
    assert_equal (1..3), RangeParser.parse([1,3])
    assert_equal (0.1..0.33), RangeParser.parse([0.1,0.33])
  end

  test "parses array of strings" do
    assert_equal (1..3), RangeParser.parse(['1','3'])
    assert_equal (0.1..0.33), RangeParser.parse(['0.1','0.33'])
  end

  test "parses string of array" do
    assert_equal (1..3), RangeParser.parse('[1,3]')
    assert_equal (0.1..0.33), RangeParser.parse('[0.1,0.33]')
  end

  test "parses string of array with space" do
    assert_equal (1..3), RangeParser.parse('[1, 3]')
    assert_equal (0.1..0.33), RangeParser.parse('[0.1, 0.33]')
  end

  test "parses comma-separated string" do
    assert_equal (1..3), RangeParser.parse('1,3')
    assert_equal (0.1..0.33), RangeParser.parse('0.1,0.33')
  end

  test "parses comma-separated string with spaces" do
    assert_equal (1..3), RangeParser.parse('1    ,        3')
    assert_equal (0.1..0.33), RangeParser.parse('0.1   ,   0.33')
  end

end
