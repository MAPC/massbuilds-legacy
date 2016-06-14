module API
  module V1
    class SearchResource < JSONAPI::Resource
      include Rails.application.routes.url_helpers

      attributes :title, :query, :saved, :url

      def url
        developments_url(query: query)
      end

      def self.records(options = {})
        context = options[:context]
        context[:current_user].searches
      end

      before_save do
        @model.user_id = context[:current_user].id if @model.new_record?
      end

    end
  end
end
