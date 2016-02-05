require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest
  test 'root' do
    skip
    assert_routing '/', {controller: 'developments', action: 'index'}
  end

  test 'default api version' do
    assert_routing('http://api.test.host/searches',
      {subdomain: 'api', controller: 'api/v1/searches', action: 'index'})
  end

  test 'api version parameter' do
    assert_routing('http://api.test.host/searches?api_version=1',
      {subdomain: 'api', controller: 'api/v1/searches', action: 'index'})
  end

  test 'api version in header' do
    ActionDispatch::TestRequest::DEFAULT_ENV['action_dispatch.request.accepts'] = 'application/org.dd.v1'
    assert_routing('http://api.test.host/searches',
      {subdomain: 'api', controller: 'api/v1/searches', action: 'index'})
  end

  test 'wildcard after search' do
    assert_routing('http://test.host/developments/search',
      {controller: 'developments', action: 'search'})
    assert_routing('http://test.host/developments/search/map',
      {controller: 'developments', action: 'search', ui: 'map'})
    assert_routing('http://test.host/developments/search/list',
      {controller: 'developments', action: 'search', ui: 'list'})
  end
end
