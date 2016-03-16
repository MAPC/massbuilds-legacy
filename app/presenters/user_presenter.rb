class UserPresenter < Burgundy::Item
  include ActionView::Helpers

  def first_name
    item.first_name.titleize
  end

  def last_name
    item.last_name.titleize
  end

  def short_name
    "#{first_name} #{last_name.chars.first}."
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def joined
    "#{time_ago_in_words item.created_at} ago"
  end

  def gravatar_url
    @gravatar_url ||= "https://secure.gravatar.com/avatar/#{hashed_email}"
  end

  def active_memberships
    item.memberships.where(state: :active).includes(:organization)
  end

  def pending_memberships
    item.memberships.where(state: :pending).includes(:organization)
  end

  def primary_organization
    item.organizations.first
  end
end
