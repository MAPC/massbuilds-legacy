class ContributorPresenter < Burgundy::Item
	def self.first_name
		first_name.titleize
	end

	def self.last_name
		last_name.titleize
	end

	def short_name
		"#{first_name} #{last_name.chars.first}."
	end

  def full_name
    "#{first_name} #{last_name}"
  end
end