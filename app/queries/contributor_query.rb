class ContributorQuery
  def initialize(relation)
    @relation = relation
  end

  def find
    @relation.edits.includes(:editor).where(state: 'applied')
  end
end
