# Extra special thanks to
# http://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails

class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    (hash || {}).with_indifferent_access
  end
end
