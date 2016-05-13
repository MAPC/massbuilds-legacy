class Export::CSV

  def initialize(record)
    @record = record
  end

  def render
    [@record.to_csv, options]
  end

  def options
    { type: Mime::CSV, disposition: disposition }
  end

  private

  def disposition
    "attachment; filename=#{@record.title.to_s.parameterize}.csv"
  end
end
