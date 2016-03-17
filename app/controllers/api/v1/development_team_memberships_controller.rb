module API
  module V1
    class DevelopmentTeamMembershipsController < APIController

      before_action :restrict_access, except: [:index, :show]

    end
  end
end
