class DevelopmentSerializer

  def initialize(record, options = {})
    @record  = record
    @options = options
  end

  def to_row
    [
      attributes.keys.map { |key| ensure_csv_ready(@record.send(key)) },
      DevelopmentTeamSerializer.new(@record, max_team_size).to_row
    ].flatten
  rescue
    []
  end

  def to_header
    [
      attributes.keys,
      DevelopmentTeamSerializer.new(@record, max_team_size).to_header
    ].flatten
  rescue
    []
  end

  private

  def attributes
    return only_attributes   if only?
    return except_attributes if except?
    base_attributes
  end

  def base_attributes
    base = @record.attributes
    base['city'] = @record.municipality
    # TODO list each of these strings as array in default
    # initialization option :reject, then loop through.
    base.reject! { |k, _v| k.include? 'street_view_' }
    base.reject! { |k, _v| k.include? 'walkscore'    }
    base.reject! { |k, _v| k.include? 'parcel'       }
    base.reject! { |k, _v| k.include? 'point'        }
    base
  end

  def only?
    @options.fetch(:only, false)
  end

  def except?
    @options.fetch(:except, false)
  end

  def only_attributes
    base_attributes.select { |k, _v| only_selection.include? k.to_sym }
  end

  def except_attributes
    base_attributes.reject { |k, _v| except_selection.include? k.to_sym }
  end

  def only_selection
    selection :only
  end

  def except_selection
    selection :except
  end

  def selection(option)
    option = option.to_sym
    Array(@options[option]).flatten.map(&:to_sym)
  end

  def max_team_size
    @options.fetch(:max_team_size) { 0 }
  end

  def ensure_csv_ready(attribute)
    class_name = attribute.class.to_s
    if class_name.include? 'Time'
      attribute.to_s
    elsif class_name.include? 'Municipality'
      attribute.to_s
    elsif class_name.include? 'Neighborhood'
      attribute.municipality.to_s
    elsif class_name.include? 'Decimal'
      attribute.to_f
    else
      attribute
    end
  end

end
