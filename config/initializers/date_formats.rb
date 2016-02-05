Time::DATE_FORMATS[:timestamp] = Proc.new { |time|
  time.stamp("5 January 2016 at 3:59 pm EST")
}
