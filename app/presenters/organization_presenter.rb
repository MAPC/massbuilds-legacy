class OrganizationPresenter < Burgundy::Item
  def members
    UserPresenter.wrap item.members.sort_by(&:last_name)
  end

  def developments
    item.developments.uniq
  end
end
