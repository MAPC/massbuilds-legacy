require 'test_helper'

class DevelopmentAuthorizerTest < ActiveSupport::TestCase

  def authorizer
    DevelopmentAuthorizer
  end

  def user
    @_user ||= users(:normal)
  end

  # For developments on which they are a team member
  # Municipal staff: any development in that municipality
  #     Can approve or reject edits
  #     Can approve or reject a claim

  # Known Users
  #   Can approve or decline edits on which their organization is a development team member
  #   Can create new developments

end
