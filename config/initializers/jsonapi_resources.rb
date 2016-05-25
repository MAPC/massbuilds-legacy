JSONAPI.configure do |config|
  config.default_paginator = :paged

  config.default_page_size = 10
  config.maximum_page_size = 50
end
