namespace :digest do

  task daily: :environment do
    DigestJob.new(:daily).perform
  end

  task weekly: :environment do
    DigestJob.new(:weekly).perform
  end

end
