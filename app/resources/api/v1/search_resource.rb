module API
  module V1
    class SearchResource < JSONAPI::Resource
      attributes :query, :saved

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
