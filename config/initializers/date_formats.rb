Date::DATE_FORMATS[:subject] = Proc.new {|date|
  date.stamp("Sunday, 2 Feb 2016")
}
