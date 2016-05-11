require 'test_helper'

class JSONAPITest < ActiveSupport::TestCase

  def setup
    @base_url        = 'http://example.com'
    @route_formatter = JSONAPI.configuration.route_formatter
    @search          = searches(:exact)
  end

  class MockResource < JSONAPI::Resource
  end

  def resource
    MockResource
  end

  def filters
    resource.filters
  end

  test 'route without /api in path' do
    primary_resource_klass = API::V1::SearchResource

    config = {
      base_url: @base_url,
      route_formatter: @route_formatter,
      primary_resource_klass: primary_resource_klass,
    }

    builder = JSONAPI::LinkBuilder.new(config)
    source  = primary_resource_klass.new(@search, nil)
    expected_link = "#{@base_url}/searches/#{source.id}"

    assert_equal expected_link, builder.self_link(source)
  end

  test '#range_filters' do
    range_filter_names.each { |f| refute_includes filters, f }
    resource.range_filter(range_filter_names.first)
    resource.range_filters(range_filter_names)
    range_filter_names.each { |f| assert_includes filters, f }
  end

  test '#boolean_filters' do
    boolean_filter_names.each { |f| refute_includes filters, f }
    resource.boolean_filters(boolean_filter_names)
    boolean_filter_names.each { |f| assert_includes filters, f }
  end

  test 'singular aliases' do
    assert_respond_to resource, :range_filter
    assert_respond_to resource, :boolean_filter
  end

  def range_filter_names
    %i( sample filter names for ranged scopes )
  end

  def boolean_filter_names
    %i( several boolean attributes )
  end

end
