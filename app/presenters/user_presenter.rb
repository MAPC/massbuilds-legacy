class UserPresenter < Burgundy::Item

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
end