module API
  module V1
    class DevelopmentsController < APIController
      before_action :restrict_access, only: [:create, :update]
      after_action  :log_search, only: [:index]

      def update
        @request = JSONAPI::Request.new(params, context: context,
          key_formatter: key_formatter,
          server_error_callbacks: (self.class.server_error_callbacks || []))
        unless @request.errors.empty?
          render_errors(@request.errors)
        else
          development = Development.find params[:id]
          development.assign_attributes(update_params)
          if development.changes.any? && development.valid?
            persist!(development)
            render json:         serialized_resource(development),
                   content_type: JSONAPI::MEDIA_TYPE,
                   status:      :accepted
          else
            raise JSONAPI::Exceptions::ValidationErrors.new(resource(development))
          end
        end
      rescue => e
        handle_exceptions(e)
      ensure
        if response.body.size > 0
          response.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
        end
      end

      private

      def serialized_resource(development)
        JSONAPI::ResourceSerializer.new(DevelopmentResource).
          serialize_to_hash(resource(development))
      end

      def resource(development)
        DevelopmentResource.new(development, nil)
      end

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
        development.reload # Clear out changes before rendering.
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

      def update_params
        Hash[
          params.fetch(:data).fetch(:attributes).map { |k, v|
            [k.underscore, v]
          }
        ]
      end

    end
  end
end
