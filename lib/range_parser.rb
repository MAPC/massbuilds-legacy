# Given an Array or String in the form of [min, max]
# convert it to a Range of min..max.
# TODO: Return a single value or a single value range (val..val)
#       in the event a single value or repetitive value is given.
module RangeParser

  def self.parse(value)
    if value.is_a? Array
      Range.new(*value.map(&:to_f))
    else
      Range.new(*value.match(self.regex).captures.map(&:to_f))
    end
  end

  def self.regex
    /([\d\.]+)\s*,\s*([\d\.]+)/
  end

end

# def range_parser(value)
#   (\d+,\d+)
#   array = value.to_s.delete('[ ]').split(',')
#   if array.length < 2
#     array.first
#   else
#     array
#   end
# end
