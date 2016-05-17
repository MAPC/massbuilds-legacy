require 'test_helper'
require 'employment_estimator'

class EmploymentEstimatorTest < ActiveSupport::TestCase

  def estimator
    @_estimator ||= EmploymentEstimator.new(subject)
  end

  def subject
    @_subject ||= Development.new(fa_ret: 750)
  end

  def test_breakdown
    breakdown = { fa_ret: 1 }
    assert_equal breakdown, estimator.breakdown
  end

  def test_perform
    assert_equal 1, estimator.estimate
  end

end
