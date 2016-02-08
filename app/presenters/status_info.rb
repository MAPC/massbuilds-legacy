require "#{Rails.root}/lib/refinements/roundable"
class StatusInfo
  using Roundable

  def initialize(item)
    @item = item
  end

  attr_reader :item

  def status_with_year
    if @item.completed?
      "#{@item.status.titleize} (#{@item.year_compl})"
    else
      "#{@item.status.titleize} (#{prefix}#{year})"
    end
  end

  def year
    if year_gte_10_yrs_from_now
      "#{bottom_of_range}-#{top_of_range}"
    else
      @item.year_compl.to_s
    end
  end

  def status_icon
    status_objects.fetch(@item.status).fetch(:icon)
  end

  def prefix
    status_objects.fetch(@item.status).fetch(:year_prefix) { '' }
  end

  private

  def status_objects
    {
      completed:       { icon: :checkmark},
      in_construction: { icon: :configure, year_prefix: 'est. ' },
      projected:       { icon: :find,      year_prefix: 'for '  },
      planning:        { icon: :calendar,  year_prefix: 'est. ' }
    }.with_indifferent_access
  end

  def year_gte_10_yrs_from_now
    @item.year_compl.to_i >= 10.years.from_now.year
  end

  def bottom_of_range
    @item.year_compl.round_down(10)
  end

  def top_of_range
    @item.year_compl.round_down(10) + 10
  end

end
