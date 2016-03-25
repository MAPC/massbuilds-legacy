class DevelopmentsSerializer

  attr_reader :developments, :max_team_dev

  def initialize(developments)
    raise ArgumentError if Array(developments).empty?
    @developments = developments
    @max_team_dev = development_with_largest_team
  end

  def to_csv
    CSV.generate do |csv|
      csv << to_header
      @developments.each { |d|
        csv << DevelopmentSerializer.new(d, max_team_size: max).to_row
      }
    end
  end

  def to_header
    DevelopmentSerializer.new(@max_team_dev, max_team_size: max).to_header
  end

  private

  def max
    # Trigger the count if it's not already cached
    @max_team_dev.team_membership_count ||=
      @max_team_dev.team_memberships.count
  end

  def development_with_largest_team
    @developments.max_by(&:team_membership_count)
  end
end
