class DigestPresenter < Burgundy::Item

  def subscriptions
    @subscriptions ||= subscriptions_needing_update
  end

  def places
    @places ||= subscribed('Place')
  end

  def searches
    @searches ||= subscribed('Search')
  end

  def developments
    @developments ||= subscribed('Development')
  end

  # def unique_developments
  #   developments - related_developments
  # end

  # def related_developments
  #   searches.flat_map(&:developments) + places.flat_map(&:developments)
  # end

  def user
    item
  end

  def user_last_checked
    user.last_checked_subscriptions
  end

  private

  def subscribed(class_name)
    subs = subscriptions.where(
      subscribable_type: class_name
    ).map(&:subscribable)
    return DevelopmentPresenter.wrap(subs) if class_name == 'Development'
    subs.map do |item|
      OpenStruct.new(
        name: item.name,
        developments: DevelopmentPresenter.wrap(item.developments)
      )
    end
  end

end
