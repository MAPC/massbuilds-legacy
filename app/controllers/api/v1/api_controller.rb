module API
  module V1
    class APIController < JSONAPI::ResourceController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include ActionController::MimeResponds

      def context
        { current_user: current_user }
      end

      private

      def restrict_access
        unless restrict_access_by_params || restrict_access_by_header
          render json: { message: 'Invalid API key.' }, status: 401
          return
        end

        @current_user = @api_key.user if @api_key
      end

      def restrict_access_by_header
        return true if @api_key
        authenticate_with_http_token { |token|
          @api_key = APIKey.find_by(token: token)
        }
      end

      def restrict_access_by_params
        return true if @api_key
        @api_key = APIKey.find_by(token: params[:api_key])
      end

    end
  end
end
