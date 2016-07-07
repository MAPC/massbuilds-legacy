JSONAPI.configure do |config|
  config.default_paginator = :paged

  config.default_page_size = 10
  config.maximum_page_size = 4000

  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count

  # config.top_level_meta_include_page_count = true
  # config.top_level_meta_page_count_key = :page_count
end
