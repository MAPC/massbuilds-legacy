class CsvSerializer

  def initialize(record, options={})
    @record = record
    @options = options
  end

  def to_row
    attributes.values.map do |attribute|
      ensure_csv_ready(attribute)
    end
  rescue
    []
  end

  def to_header
    attributes.keys
  rescue
    []
  end


  private

    def attributes
      if @options.fetch(:only, false)
        @record.attributes.select{|k,v| only_selection.include? k.to_sym }
      elsif @options.fetch(:except, false)
        @record.attributes.reject{|k,v| except_selection.include? k.to_sym }
      else
        @record.attributes
      end
    end

    def only_selection
      Array(@options[:only]).map(&:to_sym)
    end

    def except_selection
      Array(@options[:except]).map(&:to_sym)
    end

    def ensure_csv_ready(attribute)
      if attribute.class.to_s.include? 'Time'
        attribute.to_s
      else
        attribute
      end
    end

end
