require 'active_record/fixtures'

module FileFixtureExtension
  def file(file_name)
    File.open(Rails.root.join('test/fixtures/', file_name), 'rb') do |f|
      "!!binary \"#{Base64.strict_encode64(f.read)}\""
    end
  end
end

ActiveRecord::FixtureSet.extend FileFixtureExtension
