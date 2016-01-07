class CsvSerializer

  def initialize(record)
    @record = record
  end

  def to_row
    @record.attributes.values.map do |attribute|
      if attribute.class.to_s.include? 'Time'
        attribute.to_s
      else
        attribute
      end
    end
  rescue
    []
  end

  def to_header
    @record.attributes.keys
  rescue
    []
  end

end
