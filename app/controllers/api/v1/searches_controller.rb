module API
  module V1
    class SearchesController < APIController

      # Copied from AmberBit. TODO Could probably be more concise.
      # https://www.amberbit.com/blog/2014/2/19/building-and-documenting-api-in-rails/
      before_action :restrict_access

      private

        def search_params
          params.permit(:api_key)
        end

    end
  end
end
