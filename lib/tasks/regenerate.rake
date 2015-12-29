namespace :db do
  desc "Drop, re-create, seed, and sample."
  task regen: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed_fu'].invoke
    Rake::Task['db:sample'].invoke
  end
end
