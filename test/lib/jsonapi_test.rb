require 'test_helper'

class JSONAPITest < ActiveSupport::TestCase

  def setup
    @base_url        = "http://example.com"
    @route_formatter = JSONAPI.configuration.route_formatter
    @search          = searches(:exact)
  end

  test "route without /api in path" do
    primary_resource_klass = API::SearchResource

    config = {
      base_url: @base_url,
      route_formatter: @route_formatter,
      primary_resource_klass: primary_resource_klass,
    }

    builder = JSONAPI::LinkBuilder.new(config)
    source  = primary_resource_klass.new(@search, nil)
    expected_link = "#{ @base_url }/searches/#{ source.id }"

    assert_equal expected_link, builder.self_link(source)
  end


end

