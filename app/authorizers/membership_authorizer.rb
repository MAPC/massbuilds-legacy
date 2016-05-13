class MembershipAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user, options={})
    !user.member_of? options.fetch(:for)
  end

  def updatable_by?(user)
    # TODO: May want to include safe navigation
    user == resource.organization.admin && only_changing_state?(resource)
  end

  private

  def only_changing_state?(resource)
    resource.changes.keys.size == 1 && resource.changes.include?('state')
  end

end
