class ReportPresenter < Burgundy::Item

  EXPORT_RESULT_LIMIT = nil # formerly 100

  def id
    item.id || nil
  end

  def developments
    item.results.limit(EXPORT_RESULT_LIMIT)
  end

  def fields
    [numeric_fields, boolean_fields].flatten
  end

  def numeric_fields
    Development::NUMERIC_FIELDS
  end

  def boolean_fields
    Development::BOOLEAN_FIELDS
  end

  def projected
    statuses.projected
  end

  def planning
    statuses.planning
  end

  def in_construction
    statuses.in_construction
  end

  def completed
    statuses.completed
  end

  def status_keys
    Development.status.values
  end

  def statuses
    @statuses ||= OpenStruct.new(prepare_statuses)
  end

  def criteria
    query
  end

  def markers
    # Use lazy evaluation and a small batch size to limit the memory allocated
    # by the referencing of all the developments and generating strings for
    # each location. Instead, we generate one long string for the whole set,
    # before rendering.

    # Alternate strategy: use pluck to get latitude and longitude, and stitch
    # back together, instead of using Development#location.
    developments.pluck(:latitude, :longitude).
      map { |coords| "L.marker(#{coords.map(&:to_f)}, { icon: dotIcon })" }.
      join(', ')
  end

  def to_csv
    raise NoMethodError, 'This method has been disabled in favor of Carto'
    # DevelopmentsSerializer.new(developments).to_csv
  end

  private

  def prepare_statuses
    status_keys.inject(Hash.new) do |hash, v|
      hash[v.to_sym] = summarize(v)
      hash
    end
  end

  def summarize(status)
    # TODO: Combine into a single scope, if possible.
    ids = developments.where(status: status).pluck(:id)
    devs = Development.where(id: ids)

    attrs = []

    Development::NUMERIC_FIELDS.each do |attribute|
      attrs << [attribute, devs.sum(attribute)]
    end

    Development::BOOLEAN_FIELDS.each do |attribute|
      attrs << [attribute, devs.where(attribute => true).count]
    end

    Hash[attrs].merge({ name: status.to_s.titleize, count: ids.count })
  end

end
