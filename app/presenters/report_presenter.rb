class ReportPresenter < Burgundy::Item

  EXPORT_RESULT_LIMIT = 100

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
    %i( tothu  singfamhu twnhsmmult lgmultifam commsf
        fa_ret fa_ofcmd  fa_indmf   fa_whs
        fa_rnd fa_edinst fa_other fa_hotel hotelrms )
  end

  def boolean_fields
    %i( rdv   asofright phased  cancelled
        ovr55 clusteros stalled )
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

  def to_csv
    DevelopmentsSerializer.new(developments).to_csv
  end

  private

  def prepare_statuses
    statuses = {} # TODO: Replace with #inject
    Development.status.values.each {|v| statuses[v.to_sym] = prepare_values(v) }
    statuses
  end

  def prepare_values(status)
    devs = developments.where(status: status)
    attrs = [[:name, status.to_s.titleize], [:count, devs.size]]
    numeric_fields.each do |attribute|
      attrs << [attribute, devs.pluck(attribute).compact.sum]
    end
    boolean_fields.each do |attribute|
      attrs << [attribute, devs.where(attribute => true).count]
    end
    Hash[attrs]
  end

end
