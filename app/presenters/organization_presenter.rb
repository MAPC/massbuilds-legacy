class OrganizationPresenter < Burgundy::Item
  def members
    UserPresenter.wrap item.active_members.sort_by(&:last_name)
  end

  def developments
    municipal? ? place.developments : item.developments
  end
end
