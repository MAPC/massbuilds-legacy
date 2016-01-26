class DevelopmentsSerializer

  attr_reader :developments, :max_team_dev

  def initialize(developments)
    raise ArgumentError if Array(developments).empty?
    @developments = developments
    @max_team_dev = development_with_largest_team
  end

  def to_csv
    max = @max_team_dev.team_membership_count ||= @max_team_dev.team_memberships.count

    CSV.generate do |csv|
      csv << self.to_header
      @developments.each { |d|
        csv << DevelopmentSerializer.new(d, max_team_size: max).to_row
      }
    end
  end

  # def file
  #   to_csv, but in a file perhaps?
  # end

  def to_header
    DevelopmentSerializer.new(@max_team_dev).to_header
  end

  private

    def development_with_largest_team
      @developments.max_by(&:team_membership_count)
    end
end
