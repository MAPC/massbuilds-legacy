namespace :migrate do

  namespace :users do
    task download: :environment do
    end

    task upload: :environment do
    end
  end


  namespace :orgs do
    organizations_file = 'db/import/organizations.csv'
    task :in => :environment do
      CSV.foreach organizations_file, headers: true do |row|
        attributes = {
          creator: User.find_by(first_name: 'Importer'),
          name:     canonical_name(row),
          short_name: short_name(row),
          website:  row['website'].to_s.strip,
          location: row['location'].to_s.strip,
          email:    row['email'].to_s.strip,
          gravatar_email: row['email'].to_s.strip,
          phone:    row['phone'].to_s.strip,
          address:  row['address'].to_s.strip,
          abbv:     row['abbv'].to_s.strip
        }
        org = Organization.find_or_initialize_by attributes
        if org.save
          print '.'
        else
          puts org.errors.full_messages
          puts org.inspect
          raise
        end
      end
    end

    task memberships: :environment do
      CSV.foreach organizations_file, headers: true do |row|
        dev = Development.find_by(name: row['ddname'])
        development.create_development_team_membership!(
          role: :developer,
          organization: Organization.find_by(name: canonical_name(row))
        )
      end
    end

    def canonical_name(row)
      org_name = row['organization_name']
      (org_name.present? ? org_name : row['name']).strip
    end

    def short_name(row)
      tokens = canonical_name(row).split(' ')
      if tokens.first.to_i != 0 # If it starts with a number
        tokens.first(3).join(' ')  # Return first 3, like '44 Prince Street'
      else
        tokens.first(2).join(' ')
      end
    end
  end


  namespace :developments do
    task download: :environment do
      # Use the query to download a CSV of Development attributes
      # This may need to be done manually, SSH'd into the server,
      # with a COPY statement.
    end

    task upload: :environment do
      # For each row in the resulting CSV
        # Initialize or create a new development from the DevelopmentConverter attributes
        # Add relationships from the DevelopmentConverter relationships
    end
  end

end

# query = <<-EOS
#   SELECT
#     development_project.dd_id,
#     development_project.ddname,
#     development_zoningtool.name AS zoning_tool,
#     development_projectstatus.name AS status,
#     development_walkscore.status      AS walkscore_status,
#     development_walkscore.walkscore   AS walkscore_walkscore,
#     development_walkscore.description AS walkscore_description,
#     development_walkscore.updated     AS walkscore_updated,
#     development_walkscore.snapped_lat AS walkscore_snapped_lat,
#     development_walkscore.snapped_lon AS walkscore_snapped_lon
#   FROM
#     development_project
#   INNER JOIN
#     development_zoningtool ON
#       development_project.ch40_id = development_zoningtool.id
#   INNER JOIN
#     development_projectstatus ON
#       development_project.status_id = development_projectstatus.id
#   INNER JOIN
#     development_walkscore ON
#       development_project.walkscore_id = development_walkscore.id
#   LIMIT 1;
# EOS
