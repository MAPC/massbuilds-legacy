module API
  module V1
    class SearchesController < APIController

      before_action :restrict_access

      private

      def search_params
        params.permit(:api_key)
      end

    end
  end
end
