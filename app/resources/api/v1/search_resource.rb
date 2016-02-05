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

      def save
        @model.user ||= context[:current_user]
        super
      end
    end
  end
end
