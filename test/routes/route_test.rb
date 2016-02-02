require "test_helper"

class RouteTest < ActionDispatch::IntegrationTest
  test 'root' do
    skip
    assert_routing "/", {controller: "developments", action: "index"}
  end

  test 'default api version' do
    assert_routing("http://api.test.host/searches",
      {subdomain: "api", controller: "api/v1/searches", action: "index"})
  end

  test 'api version parameter' do
    assert_routing("http://api.test.host/searches?api_version=1",
      {subdomain: "api", controller: "api/v1/searches", action: "index"})
  end

  test 'api version in header' do
    ActionDispatch::TestRequest::DEFAULT_ENV["action_dispatch.request.accepts"] = "application/application/org.dd.v1"
    assert_routing("http://api.test.host/searches",
      {subdomain: "api", controller: "api/v1/searches", action: "index"})
  end
end
