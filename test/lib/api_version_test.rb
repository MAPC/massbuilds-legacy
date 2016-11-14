require 'test_helper'

require 'api_version'

class APIVersionTest < ActiveSupport::TestCase

  def v1
    @_v1 ||= APIVersion.version(1)
  end

  def v2
    @_v2 ||= APIVersion.v(2, default: true)
  end

  def request_v1
    @_r1 ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json; application/org.massbuilds.v1+json'
    })
  end

  def request_v2
    @_r2 ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json; application/org.massbuilds.v2+json'
    })
  end

  def request_no_version
    @_rno ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json;'
    })
  end

  test 'matches v1' do
    expected_v1 = { module: 'V1',
      header: {
        name: 'Accept',
        value: 'application/vnd.api+json; application/org.massbuilds.v1'
      },
      parameter: { name: 'version', value: '1' },
      default: false
    }
    assert_equal expected_v1, v1
  end

  test 'matches v2' do
    expected_v2 = { module: 'V2',
      header: {
        name: 'Accept',
        value: 'application/vnd.api+json; application/org.massbuilds.v2'
      },
      parameter: { name: 'version', value: '2' },
      default: true
    }
    assert_equal expected_v2, v2
  end
end
