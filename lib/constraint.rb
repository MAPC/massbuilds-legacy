class Constraint
  def initialize(regex, host_method=:host)
    @regex = regex
  end

  def matches?(request)
    @regex.match request.send(host_method)
  end
end
