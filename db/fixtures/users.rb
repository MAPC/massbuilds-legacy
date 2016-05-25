# This user requires a password, but we don't want to store it
# in plaintext here. When running a seed task with this file, run it as:
#
#   IMPORTER_BOT_PASSWORD=the_password_you_want rake db:seed_fu
#
# or temporarily set IMPORTER_BOT_PASSWORD as an environment variable on
# the hosting platform.

User.seed(:id,
  {
    id: 1,
    first_name: 'Importer',
    last_name:  'Bot',
    encrypted_password: BCrypt::Password.create(ENV.fetch('IMPORTER_BOT_PASSWORD'))
  }
)

