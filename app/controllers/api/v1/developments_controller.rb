module API
  module V1
    class DevelopmentsController < APIController
      before_action :restrict_access, only: [:create, :update]
      after_action  :log_search, only: [:index]

      def update
        development = Development.find(params[:id])
        if development.present? # WARN: NilCheck
          persist! development
          # Serialize object like a GET request, according to spec
          render json: JSONAPI::ResourceSerializer.new(DevelopmentResource).
            serialize_to_hash(DevelopmentResource.new(development, nil)),
            content_type: JSONAPI::MEDIA_TYPE
        end
      end

      private

      def persist!(development)
        # Without a transaction, this can become a dangling edit with
        # no changes, which causes an error in our timid pending edits template.
        ActiveRecord::Base.transaction do
          edit = development.edits.create!(editor: current_user)
          development.changes.each_pair do |name, diff|
            edit.fields.create!(
              name:   name,
              change: { from: diff.first, to: diff.last }
            )
          end
        end
      end

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
