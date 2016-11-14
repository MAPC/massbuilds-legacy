require 'test_helper'
require 'employment_estimator'

class EmploymentEstimatorTest < ActiveSupport::TestCase

  def estimator
    @_estimator ||= EmploymentEstimator.new(subject)
  end

  def subject
    @_subject ||= Development.new(fa_ret: 750)
  end

  test 'breakdown' do
    breakdown = { fa_ret: 1 }
    assert_equal breakdown, estimator.breakdown
  end

  test 'perform' do
    assert_equal 1, estimator.estimate
  end

  test 'calculation' do
    d.commsf = d.fa_ret = 0
    d.save!
    assert_equal 0, d.estemp
    d.commsf = d.fa_ret = 750
    d.save!
    assert d.estemp > 0
  end

end
