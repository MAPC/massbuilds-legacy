class StatusInfo

  def initialize(item)
    @item = item
  end

  attr_reader :item

  def status_with_year
    if @item.completed?
      "#{@item.status.titleize} (#{@item.year_compl})"
    else
      "#{@item.status.titleize} (est. #{@item.year_compl})"
    end
  end

end
