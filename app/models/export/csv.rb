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
    "attachment; filename=export-#{filename}.csv"
  end

  def filename
    @record.query.flatten.map(&:dasherize).first(4).join('-').gsub(/\[|\]/, '')
  end
end
