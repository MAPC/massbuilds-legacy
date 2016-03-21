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

  def frequency
    user.mail_frequency
  end

  def user_last_checked
    user.last_checked_subscriptions
  end

  private

  def subscribed(class_name)
    if class_name == 'Development'
      wrapped_developments(class_name)
    else
      raw_subscriptions(class_name)
    end
  end

  def raw_subscriptions(class_name)
    subscriptions.where(subscribable_type: class_name).map(&:subscribable)
  end

  def wrapped_developments(class_name)
    DevelopmentPresenter.wrap(raw_subscriptions(class_name))
  end

end
