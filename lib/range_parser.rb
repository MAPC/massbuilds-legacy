# Given an Array or String in the form of [min, max]
# convert it to a Range of min..max.
# TODO: Return a single value or a single value range (val..val)
#       in the event a single value or repetitive value is given.
module RangeParser

  def self.parse(value)
    @value = value
    return infinity_range unless @value.present?
    if @value.is_a? Array
      return parse_rejoined_string if @value.first.is_a?(String)
      Range.new *@value.map(&:to_f)
    else
      parse_string
    end
  end

  private

  def self.parse_rejoined_string
    @value = @value.join ','
    parse_string
  end

  def self.parse_string
    Range.new *@value.match(self.regex).captures.map(&:to_f)
  end

  def self.regex
    /([\d\.]+)['"]?\s*,\s*['"]?([\d\.]+)/
  end

  def self.digits_regex
    /(\d+)/
  end

  def self.infinity_range
    (-Float::INFINITY..Float::INFINITY)
  end

end
