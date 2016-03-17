require 'test_helper'

module API
  module V1
    class DevelopmentTeamMembershipsControllerTest < ActionController::TestCase

      def setup
        JSONAPI.configuration.raise_if_parameters_not_allowed = true
      end

      def set_content_type_header!
        @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
      end

      def set_auth_header_for_user!(user)
        @request.headers['Authorization'] = "Token #{user.api_key}"
      end

      def membership
        @_membership ||= development_team_memberships(:one)
      end

      def development
        @_development ||= developments(:one)
      end

      def organization
        @_organization ||= organizations(:mapc)
      end

      def user
        @_user ||= users(:tim)
      end

      test 'should get index' do
        get :index
        assert_response :success
      end

      test 'should get show' do
        get :show, id: membership.id
        assert_response :success
      end

      test 'create with user authorized through header' do
        set_content_type_header!
        set_auth_header_for_user!(user)
        assert_difference 'DevelopmentTeamMembership.count' do
          post :create, valid_create_payload
        end
        assert_response :created, response.body
      end

      test 'create with user authorized through data param' do
        set_content_type_header!
        payload = valid_create_payload.merge(key_payload)
        assert_difference 'DevelopmentTeamMembership.count' do
          post :create, payload
        end
        assert_response :created, response.body
      end

      test 'create with no user' do
        set_content_type_header!
        post :create, valid_create_payload
        assert_response :unauthorized, response.body
      end

      test 'update, header' do
        set_content_type_header!
        set_auth_header_for_user!(user)
        assert_no_difference 'DevelopmentTeamMembership.count' do
          patch :update, id: membership.id, data: valid_update_payload
        end
        assert_response :success, response.body
      end

      test 'update, param' do
        set_content_type_header!
        assert_no_difference 'DevelopmentTeamMembership.count' do
          patch :update, id: membership.id, data: valid_update_payload,
            api_key: user.api_key.token
        end
        assert_response :success, response.body
      end

      test 'update, no user' do
        set_content_type_header!
        assert_no_difference 'DevelopmentTeamMembership.count' do
          patch :update, id: membership.id, data: valid_update_payload
        end
        assert_response :unauthorized, response.body
      end

      test 'destroy, header' do
        set_content_type_header!
        set_auth_header_for_user!(user)
        assert_difference 'DevelopmentTeamMembership.count', -1 do
          delete :destroy, id: membership.id
        end
        assert_response :success, response.body
      end

      test 'destroy, param' do
        set_content_type_header!
        assert_difference 'DevelopmentTeamMembership.count', -1 do
          delete :destroy, id: membership.id, api_key: user.api_key.token
        end
        assert_response :success, response.body
      end

      test 'destroy, no user' do
        set_content_type_header!
        delete :destroy, id: membership.id
        assert_response :unauthorized, response.body
      end

      # test 'create duplicate' do
      #   skip
      # end

      # test 'update duplicate' do
      #   skip
      # end

      private

      def results(response)
        JSON.parse(response.body)['data']
      end

      def valid_create_payload
        {
          data: {
            type: 'development-team-memberships',
            attributes: { role: 'architect' },
            relationships: {
              development:  {
                data: { type: 'developments',  id: development.id  }
              },
              organization: {
                data: { type: 'organizations', id: organization.id }
              }
            }
          }
        }
      end

      def valid_update_payload
        {
          id: membership.id.to_s,
          type: 'development-team-memberships',
          attributes: { role: 'architect' },
          relationships: {
            development:  {
              data: { type: 'developments',  id: development.id  }
            },
            organization: {
              data: { type: 'organizations', id: organization.id }
            }
          }
        }
      end

      def key_payload
        { api_key: user.api_key.token }
      end

    end
  end
end
