Time::DATE_FORMATS[:timestamp] = Proc.new { |time|
  time.stamp("5 January 2016 at 3:59 pm EST")
}

Time::DATE_FORMATS[:subject] = proc { |date|
  date.stamp('Sunday, 2 Feb 2016')
}

Date::DATE_FORMATS[:subject] = proc { |date|
  date.stamp('Sunday, 2 Feb 2016')
}
