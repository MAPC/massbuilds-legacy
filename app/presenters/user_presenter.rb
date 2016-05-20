class UserPresenter < Burgundy::Item
  include Rails.application.routes.url_helpers
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

  def gravatar_url(size: 120)
    @gravatar_url ||=
      "https://secure.gravatar.com/avatar/#{hashed_email}?s=#{size}&d=identicon"
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

  def second_label_data
    if primary_organization
      { label2: 'Member of', data2: organization_url(primary_organization) }
    else
      { label2: 'Joined', data2: joined }
    end
  end

end
