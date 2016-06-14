require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest

  test 'default api version' do
    rte = { controller: 'api/v1/searches', action: 'index' }
    assert_routing('http://api.test.host/searches', rte)
  end

  test 'api version parameter' do
    rte = { controller: 'api/v1/searches', action: 'index' }
    assert_routing('http://api.test.host/searches?api_version=1', rte)
  end

  test 'api version in header' do
    env = ActionDispatch::TestRequest::DEFAULT_ENV
    env['action_dispatch.request.accepts'] = 'application/org.dd.v1'
    rte = { controller: 'api/v1/searches', action: 'index' }
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
    base = 'http://test.host/developments/'
    assert_routing base + 'map',   route_for('map')
    assert_routing base + 'table', route_for('table')
  end

  private

  def route_for(path)
    {
      ember_app: :searchapp,
      controller: 'developments',
      action: 'index',
      rest: "/#{path}"
    }
  end
end
