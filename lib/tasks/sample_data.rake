namespace :db do
  desc "Load sample application data."
  task sample: :environment do
    require 'faker'

    #      Users
    #=================

    matt_c  = User.create!(
      email:      'mcloyd@mapc.org',
      password:   'password',
      first_name: 'Matt',
      last_name:  'Cloyd'
    )
    matt_g = User.create!(
      email:      'mgardner@mapc.org',
      password:   'drowssap',
      first_name: 'Matt',
      last_name:  'Gardner'
    )
    tim_r = User.create!(
      email:      'treardon@mapc.org',
      password:   'pass!word',
      first_name: 'Tim',
      last_name:  'Reardon'
    )
    jessie_p =  User.create!(
      email:      'jpartridge@mapc.org',
      password:   'word!pass',
      first_name: 'Jessie',
      last_name:  'Partridge'
    )
    harlan_w = User.create!(
      email:      'harlan@mass.it',
      password:   '9238!5fj!zi?e0213ca]jdkfaj83',
      first_name: 'Harlan',
      last_name:  'Weber'
    )
    keith_m =  User.create!(
      email:      'keith@moskow-linn-architects.net',
      password:   'architectur3',
      first_name: 'Keith',
      last_name:  'Moskow'
    )
    tristan_r =  User.create!(
      email:      'tristan@bnl.com',
      password:   'bnlololol',
      first_name: 'Tristan',
      last_name:  'Romano'
    )
    john_q =  User.create!(
      email:      'jq@norfolk.com',
      password:   'qqqqqqqqqq',
      first_name: 'John',
      last_name:  'Quincy'
    )
    clara_c =  User.create!(
      email:      'carterc@camberville.ma.us.gov',
      password:   '99jZ!1djki00',
      first_name: 'Clara',
      last_name:  'Carter'
    )


    #  Organizations
    #=================


    mapc = Organization.create!(
      name:       "Metropolitan Area Planning Council",
      short_name: "MAPC",
      abbv:       "MAPC",
      location:   'Boston, MA',
      website:    'http://mapc.org',
      creator:    tim_r
    )

    massit =  Organization.create!(
      name:       'Massachusetts Department of Information Technology',
      short_name: 'MassIT',
      abbv:       'MI',
      location:   'Boston, MA',
      website:    'http://www.mass.gov/anf/research-and-tech/oversight-agencies/itd/',
      creator:    harlan_w
    )
    bra =     Organization.create!(
      name:       'Boston Redevelopment Authority',
      short_name: 'Boston Redevelopment',
      abbv:       'BRA',
      location:   'Boston, MA',
      website:    'http://bostonredevelopmentauthority.org/',
      creator:    jessie_p
    )
    norfolk = Organization.create!(
      name:       'Norfolk Construction',
      short_name: 'Norfolk',
      abbv:       'NC',
      location:   'Northborough, MA',
      website:    'www.norfolk.com',
      creator:    john_q
    )
    bnl =     Organization.create!(
      name:       "Buy 'n Large",
      short_name: "B 'n L",
      abbv:       'BNL',
      location:   'Sydney, Australia',
      website:    'http://www.imdb.com/title/tt0910970/',
      creator:    tristan_r
    )
    moskow =  Organization.create!(
      name:       'Moskow Linn Architects',
      short_name: 'Moskow Linn',
      abbv:       'MLA',
      location:   'Boston, MA',
      website:    'http://moskowlinn.com/',
      creator:    keith_m
    )
    muni =    Organization.create!(
      name:       'Camberville, Massachusetts',
      short_name: 'Camb MA',
      abbv:       'CMA',
      location:   'Camberville, MA',
      website:    'http://camb.ma',
      creator:    clara_c
    )


    #  Developments
    #=================


    godfrey = Development.create!(
      name:       'Godfrey Hotel',
      address:    '501 Washington Street',
      place:      Place.find_by(name: 'Boston'),
      state:      'MA',
      zip_code:   '02111',
      status:     :in_construction,
      website:    'http://godfreyhotelboston.com',
      year_compl: 2016,
      total_cost: 10_020_300,
      latitude:   42.3547661,
      longitude: -71.0615689,
      creator:    User.all.sample
    )

    millennium = Development.create!(
      name: 'Millennium Place',
      address: 'Washington Street',
      place: Place.find_by(name: 'Boston'),
      zip_code: '02111',
      status: :in_construction,
      website: 'http://millenniumtow.er',
      year_compl: 2017,
      total_cost: 100_000_000,
      latitude:   42.355777,
      longitude: -71.0597007,
      creator: User.all.sample
    )

    opera = Development.create!(
      name: 'Boston Opera House',
      address: '539 Washington Street',
      place: Place.find_by(name: 'Boston'),
      zip_code: '02111',
      status: :completed,
      year_compl: 1999,
      total_cost: 3_029_101,
      latitude: 42.3539817,
      longitude: -71.0623373,
      creator: User.all.sample
    )

    residences = Development.create!(
      name: 'Residences at 8 Winter',
      address: '8 Winter Street',
      place: Place.find_by(name: 'Boston'),
      zip_code: '02111',
      status: :in_construction,
      year_compl: 2017,
      total_cost: 5_000_100,
      latitude: 42.3554185,
      longitude: -71.0613328,
      creator: User.all.sample
    )

    # A ton of fake ones.
    20.times { create_development }

    #  Development Team Memberships
    #=================================


    DevelopmentTeamMembership.create!(
      development:  godfrey,
      organization: norfolk,
      role:        :developer
    )
    DevelopmentTeamMembership.create!(
      development:  godfrey,
      organization: moskow,
      role:        :architect
    )
    DevelopmentTeamMembership.create!(
      development:  godfrey,
      organization: bnl,
      role:        :landlord
    )
    DevelopmentTeamMembership.create!(
      development:  godfrey,
      organization: bra,
      role:        :developer
    )


    #  Development Histories
    #===========================

    count = Development.count * 15
    count.times do |i|
      random_edit
      puts percent_log(i, count)
    end

    #  A few new developments
    #===========================

    5.times { create_development }


    #  Searches
    #===========================

    # TODO: That return most developments
    # Searches that return all developments



    #  Places
    #===========================

    # TODO: Place that returns some from each development pool
    # What did I mean by this?


    #  Subscribe a user to
    #   place and search
    #============================

    # TODO Subscribe user to searches, places so we'll have
    # some unique developments, but not 100% unique developments




  end
end

def percent_log(num, denom)
  num = num + 1
  puts "#{((num / denom) * 100).to_f.round(2)}% complete (#{num}/#{denom})"
end


def random_edit
  edit = Edit.create!(
    development: Development.all.sample,
    editor: User.all.sample
  )
  (0..20).to_a.sample.times { random_field_edit(edit) }
  edit.send(make_state)
  if edit.applied?
    date = (0..100).to_a.sample.days.ago
    edit.applied_at = date
    edit.moderator = loop do
      mod = User.all.sample
      break mod unless edit.editor == mod
    end
  end
  edit.save
  edit
end

def make_state
  percent = (rand*100).to_i
  if percent > 90
    :present? # NO OP
  elsif percent > 70
    :declined
  else
    :applied
  end
end

def random_field_edit(edit)
  name = numeric_attributes.keys.sample
  f = FieldEdit.new(name: name, edit: edit, change: random_change(name))
  f.save if f.valid?
end

def random_change(name)
  key = name.to_sym
  from, to = 2.times.map { Array(numeric_attributes[key]).sample }
  { from: from, to: to }
end


def numeric_attributes
  {
    height:     (20..3000),
    stories:    (1..79),
    year_compl: (1990..2027),
    prjarea:    (10..100),
    singfamhu:  (0..40),
    twnhsmmult: (0..30),
    lgmultifam: (0..10),
    tothu:      (0..111),
    gqpop:      (0..50),
    rptdemp:    (0..100),
    emploss:    [0,0,0,0,0,0,0,10,30],
    estemp:     (0..100),
    commsf:     (0..20_000),
    hotelrms:   (10..300),
    onsitepark: (0..300),
    total_cost: (0..20_000_000)
  }
end


# def create_user
#   u = User.new(email: Faker::Internet.free_email, password: Faker::Internet.password(8,12))
#   assert_creation(u)
# end

def create_development
  name        = "#{Faker::Name.last_name} #{Faker::Address.street_suffix}"
  address     = "#{Faker::Address.street_address}, #{Faker::Address.city} #{Faker::Address.state_abbr} #{Faker::Address.zip}"
  year_compl  = (1990..2027).to_a.sample
  status      = [:projected, :planning, :in_construction, :completed].sample
  total_cost  = Faker::Number.number([6,7,8,9].sample)
  latitude =  ((423_121_463..423_554_819).to_a.sample / 10_000_000.to_f)
  longitude = ((-711_265_641..-710_432_225).to_a.sample / 10_000_000.to_f)
  d = Development.new(
    name: name,
    address: address,
    year_compl: year_compl,
    place: Place.all.sample,
    status: status,
    total_cost: total_cost,
    latitude: latitude,
    longitude: longitude,
    creator: User.all.sample
  )
  assert_creation(d)
end

def assert_creation(object)
  if object.save
    puts "Created #{object.class.name} -- #{object.try(:name)}"
  else
    puts object.errors.full_messages
    exit 1
  end
end
