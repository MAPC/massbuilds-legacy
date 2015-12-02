require 'test_helper'

class DevelopmentTest < ActiveSupport::TestCase
  def development
    @development ||= developments :one
  end

  alias_method :d, :development

  test "valid" do
    assert d.valid?
  end

  test "can assign attributes in JSON" do
    skip """
      Original thought was to set up safe chaining. Now, I think
      it would be better to set up a hash with indifferent access,
      that creates objects `mkdir -p`-style.
    """
    assert_not_equal 10, d.fields.housing.ov_hupipe
    d.housing.ov_hupipe = 10
    d.save ; d.reload
    assert_equal 10, d.fields.housing.ov_hupipe
  end

  test "can assign attributes in JSON safely chained" do
    skip "See above"
    assert_not_equal 10, d.housing.ov_hupipe
    d.ov_hupipe = 10
    d.save ; d.reload
    assert_equal 10, d.housing.ov_hupipe
  end

  test "raises when attribute absent" do
    skip "What am I doing."
    assert_raises(StandardError) {
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
