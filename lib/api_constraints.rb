class ApiConstraints

  attr_reader :version, :default

  def initialize(options)
    @version = options.fetch(:version)
    @default = options.fetch(:default) { false }
  end

  def matches?(req)
    @req = req
    return request_version == @version if request_version
    @default
  end

  private

    def request_version
      accept_header = @req.headers.fetch('Accept') { "" }
      if matched = accept_header.match(version_regex)
        matched.captures.first.to_i
      end
    end

    def version_regex
      /application\/org.dd.v(\d)/i
    end

    def version_string
      "application/org.dd.v#{@version}"
    end
end
