class ContributorQuery
  def initialize(relation)
    @relation = relation
  end

  def find
    @relation.edits.includes(:editor).where(applied: true)
  end
end
