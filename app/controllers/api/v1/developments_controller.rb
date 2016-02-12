module API
  module V1
    class DevelopmentsController < APIController
      # before_action :restrict_access, only: [:index]
      after_action :log_search, only: [:index]

      private

      def log_search
        if filter_params.keys.any?
          user = current_user || User.null
          Search.create!(query: filter_params, user: user)
        end
      end

      def filter_params
        params.fetch(:filter) { Hash.new }
      end

    end
  end
end
