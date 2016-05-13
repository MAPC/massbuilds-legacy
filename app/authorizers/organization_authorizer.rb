class OrganizationAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
    user.known?
  end

end
