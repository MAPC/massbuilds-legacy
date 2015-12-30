class OrganizationPresenter < Burgundy::Item
  def members
    UserPresenter.wrap item.active_members.sort_by(&:last_name).uniq
  end
end
