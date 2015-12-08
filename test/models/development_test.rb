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
    assert_equal d.fields['name'], d.name
    assert_equal d.fields[:name], d.name
  end

  test "can assign attributes to fields, as methods" do
    assert_not_equal 10, d.housing_units
    d.housing_units = 10
    assert_equal 10, d.housing_units
    # Next step: try another field. Would require store accessors
    # for all the fields.
  end

  test "can assign attributes in JSON safely chained" do
    skip "Not sure this is important"
    assert_not_equal 10, d.housing.units
    d.units = 10
    d.save ; d.reload
    assert_equal 10, d.housing.units
  end

  test "raises when attribute absent" do
    assert_raises(NoMethodError) {
      d.assign_attributes ov_hupipe_not: 10
    }
  end

  test "calculated fields" do
    skip "Not clear yet where this happens."
  end

  test "#history returns applied changes" do
    skip "Not ready yet."
    assert_nothing_raised { d.history }
    assert_not_empty d.history
    assert_instance_of Edit, d.history.first
  end

end
