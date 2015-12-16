namespace :db do
  desc "Load sample application data."
  task sample: :environment do
    require 'faker'

    user  = User.create(email: "mcloyd@mapc.org",   password: "password", first_name: "Matt", last_name: "Cloyd")
    user2 = User.create(email: "mgardner@mapc.org", password: "drowssap", first_name: "Matt", last_name: "Gardner")
    development = Development.create(
      name: "Godfrey Hotel",
      address: "501 Washington Street, Boston MA 02111",
      status: :in_construction,
      website: "http://godfreyhotelboston.com",
      total_cost: 10_020_300,
      creator: user
    )
    organization = Organization.create(
      name: "Metropolitan Area Planning Council",
      short_name: "MAPC",
      abbv: "MAPC",
      location: 'Boston, MA',
      website: 'http://mapc.org',
      creator: user
    )
    DevelopmentTeamMembership.create(
      development:  development,
      organization: organization,
      role: :developer
    )
    DevelopmentTeamMembership.create(
      development:  development,
      organization: organization,
      role: :architect
    )
    DevelopmentTeamMembership.create(
      development:  development,
      organization: organization,
      role: :landlord
    )
    DevelopmentTeamMembership.create(
      development:  development,
      organization: organization,
      role: :developer
    )
    edit1 = Edit.create(
      development: development,
      editor: user,
      fields: [EditField.create(name: 'commsf', change: {from: '12', to: '1000'})]
    )
    edit2 = Edit.create(
      development: development,
      editor: user2,
      fields: [EditField.create(name: 'prjarea', change: {from: '0', to: '10'})]
    )
    edit3 = Edit.create(
      development: development,
      editor: user,
      fields: [EditField.create(name: 'commsf', change: {from: '1000', to: '9001'})]
    )


    # 7.times { create_user }
    # 6.times { create_development }
    # 3.times { create_organization }
    puts "----> Added sample data."
  end
end


# def create_user
#   u = User.new(email: Faker::Internet.free_email, password: Faker::Internet.password(8,12))
#   assert_creation(u)
# end

# def create_development
#   name        = "#{Faker::Name.last_name} #{Faker::Address.street_suffix}"
#   address     = "#{Faker::Address.street_address}, #{Faker::Address.city} #{Faker::Address.state_abbr} #{Faker::Address.zip}"
#   status      = [:projected, :planning, :in_construction, :completed].sample
#   total_cost  = Faker::Number.number([6,7,8,9].sample)
#   d = Development.new( name: name, address: address, status: status, total_cost: total_cost, creator: User.all.sample )
#   assert_creation(d)
# end

# def create_organization
#   creator      = User.all.sample
#   name         = "#{Faker::Company.name} #{Faker::Company.suffix}"
#   short_name   = name.split(' ').first
#   website      = Faker::Internet.url
#   url_template = Faker::Internet.url('{id}')
#   location     = "#{Faker::Address.city} #{Faker::Address.state_abbr}"
#   email        = Faker::Internet.email(['hello', 'info', 'about'].sample)
#   o = Organization.new(creator: creator, name: name, short_name: short_name, website: website, url_template: url_template, location: location, email: email)
#   assert_creation(o)
# end


# def assert_creation(object)
#   if object.save
#     puts "Created #{object.class.name} -- #{object.try(:name)}"
#   else
#     puts object.errors.full_messages
#     exit 1
#   end
# end