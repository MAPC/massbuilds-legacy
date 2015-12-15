class CollectionSerializer
  def self.dump(collection)
    Array(collection).to_json
  end

  def self.load(collection)
    (collection || []).map(&:with_indifferent_access)
  end
end