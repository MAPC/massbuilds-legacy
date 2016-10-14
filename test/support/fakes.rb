module ExternalServices
  module Fakes

    class FakeStreetView
      def initialize(*args)
      end

      def image(*args)
      end
    end

    class FakeWalkScore
      def initialize(*args)
      end

      def get(*args)
        {
          status: 1,
          walkscore: 97,
          description: "Walker's Paradise",
          updated: "2016-05-08 03:52:18.803410",
          logo_url: "https://cdn.walk.sc/images/api-logo.png",
          more_info_icon: "https://cdn.walk.sc/images/api-more-info.gif",
          more_info_link: "https://www.redfin.com/how-walk-score-works",
          ws_link: "https://www.walkscore.com/score/loc/lat=42.3547038/lng=-71.0617028/?utm_source=mapc.org&utm_medium=ws_api&utm_campaign=ws_api", help_link: "https://www.redfin.com/how-walk-score-works",
          snapped_lat:
          42.354,
          snapped_lon: -71.061
        }
      end
    end

    class FakeNearestTransit
      def initialize(*args)
      end

      def get(*args)
      end
    end

    def mock_out(resource)
      resource.nearest_transit_client = FakeNearestTransit.new
      resource.street_view_client = FakeStreetView.new
      resource.walkscore_client = FakeWalkScore.new
      resource
    end

  end
end
