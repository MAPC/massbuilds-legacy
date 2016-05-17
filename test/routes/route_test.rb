require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest

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

  test 'development show goes to DevelopmentsController' do
    assert_routing 'http://test.host/developments/1', {
      controller: 'developments', action: 'show', id: '1'
    }
  end

  test 'development index goes to Ember app' do
    assert_routing 'http://test.host/developments', {
      ember_app: :searchapp, controller: 'developments', action: 'index'
    }
  end

  test 'development edit goes to Ember app' do
    edit_route = 'http://test.host/developments/1/edit'
    assert_routing edit_route, {
      ember_app: :searchapp, controller: 'developments', action: 'edit', id: '1'
    }
  end

  test 'development new goes to Ember app' do
    new_route  = 'http://test.host/developments/new'
    assert_routing new_route, {
      ember_app: :searchapp, controller: 'developments', action: 'new'
    }
  end

  test 'wildcard after search' do
    skip
    rte = { ember_app: :searchapp, controller: 'developments',
            action: 'search' }
    assert_routing('http://test.host/developments/search', rte)
    map_rte = { ember_app: :searchapp, controller: 'developments',
      action: 'search', rest: '/map' }
    assert_routing('http://test.host/developments/search/map', map_rte)
    list_rte = { ember_app: :searchapp, controller: 'developments',
      action: 'search', rest: '/list' }
    assert_routing('http://test.host/developments/search/list', list_rte)
  end
end
