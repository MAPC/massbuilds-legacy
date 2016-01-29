require 'test_helper'
require 'api_constraints'

class ApiConstraintsTest < ActiveSupport::TestCase

  def v1
    @_v1 ||= ApiConstraints.new(version: 1)
  end

  def v2
    @_v2 ||= ApiConstraints.new(version: 2, default: true)
  end

  def request_v1
    @_r1 ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json; application/org.dd.v1+json'
    })
  end

  def request_v2
    @_r2 ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json; application/org.dd.v2+json'
    })
  end

  def request_no_version
    @_rno ||= OpenStruct.new(headers: {
      'Accept' => 'application/vnd.api+json;'
    })
  end

  test "version" do
    assert_equal 1, v1.version
    assert_equal 2, v2.version
  end

  test "default" do
    refute v1.default
    assert v2.default
  end

  test "matches v1" do
    assert v1.matches?(request_v1)
  end

  test "matches v2" do
    assert v2.matches?(request_v2)
  end

  test "matches v2 by default" do
    assert v2.matches?(request_no_version)
  end

  test "does not match the wrong version" do
    refute v1.matches?(request_v2), "v1 matched v2"
    refute v2.matches?(request_v1), "v2 matched v1"
  end
end

