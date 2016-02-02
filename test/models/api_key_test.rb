require 'test_helper'

class APIKeyTest < ActiveSupport::TestCase

  def key
    @_key ||= api_keys(:one)
  end

  test 'valid' do
    assert key.valid?
  end

  test 'requires a user' do
    key.user = nil
    refute key.valid?
  end

  test 'token cannot be changed' do
    assert_raises(ActiveRecord::ActiveRecordError) {
      key.update_attribute(:token, '')
    }
  end

  test '#to_s results in token' do
    assert_equal key.token, key.to_s
  end
end
