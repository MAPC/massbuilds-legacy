require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest
  test 'root' do
    skip
    assert_routing '/', controller: 'developments', action: 'index'
  end

  test 'default api version' do
    rte = { subdomain: 'api', controller: 'api/v1/searches', action: 'index' }
    assert_routing('http://api.test.host/searches', rte)
  end

  test 'api version parameter' do
    rte = { subdomain: 'api', controller: 'api/v1/searches', action: 'index' }
    assert_routing('http://api.test.host/searches?api_version=1', rte)
  end

  test 'api version in header' do
    env = ActionDispatch::TestRequest::DEFAULT_ENV
    env['action_dispatch.request.accepts'] = 'application/org.dd.v1'
    rte = { subdomain: 'api', controller: 'api/v1/searches', action: 'index' }
    assert_routing('http://api.test.host/searches', rte)
  end

  test 'wildcard after search' do
    rte = { controller: 'developments', action: 'search' }
    assert_routing('http://test.host/developments/search', rte)
    map_rte = { controller: 'developments', action: 'search', ui: 'map' }
    assert_routing('http://test.host/developments/search/map', map_rte)
    list_rte = { controller: 'developments', action: 'search', ui: 'list' }
    assert_routing('http://test.host/developments/search/list', list_rte)
  end
end
