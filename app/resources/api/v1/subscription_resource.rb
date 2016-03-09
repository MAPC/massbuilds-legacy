module API
  module V1
    class SubscriptionResource < JSONAPI::Resource

      has_one :subscribable, polymorphic: true

      def save
        @model.user ||= context[:current_user]
        super
      end

    end
  end
end
