require 'test_helper'

class API::V1::SubscriptionsControllerTest < ActionController::TestCase
  # Duplicated from SearchesControllerTest
  # TODO Move to common module
  def setup
    JSONAPI.configuration.raise_if_parameters_not_allowed = true
  end

  def set_content_type_header!
    @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
  end

  def set_auth_header_for_user!(user)
    @request.headers['Authorization'] = "Token #{user.api_key}"
  end

  def user
    @_user ||= users(:normal)
    @_user.create_api_key
    @_user
  end

  def development
    @_dev ||= developments(:two)
  end

  def subscription
    @_subscription ||= subscriptions(:one)
  end

  test 'create with user authorized through header' do
    set_content_type_header!
    set_auth_header_for_user!(user)
    post :create, valid_subscription_data
    assert_response :created, response.body
  end

  test 'create with user authorized through data param' do
    set_content_type_header!
    post :create, valid_subscription_data.merge({api_key: user.api_key.token})
    assert_response :created, response.body
  end

  test 'create with no user' do
    set_content_type_header!
    post :create, valid_subscription_data
    assert_response :unauthorized, response.body
  end

  test 'create duplicate' do
    Subscription.create!(subscribable: development, user: user)
    set_content_type_header!
    set_auth_header_for_user!(user)
    post :create, valid_subscription_data
    assert_response :unprocessable_entity, response.body
  end

  def valid_subscription_data
    {
      data: {
        type: 'subscriptions',
        attributes: { },
        relationships: {
          subscribable: {
            data: { type: 'developments', id: development.id }
          },
        }
      }
    }
  end

end
