class DevelopmentsSerializer

  attr_reader :developments, :max_team_dev

  def initialize(developments)
    raise ArgumentError if Array(developments).empty?
    @developments = developments
    @max_team_dev = development_with_largest_team
  end

  def to_csv
    # self.to_header
    max_team_size = @max_team_dev.team_membership_count
    @developments.map { |development|
      DevelopmentSerializer.new(development, max_team_size: max_team_size).to_row
    }
  end

  # def file
  #   to_csv, but in a file somehow?
  # end

  def to_header
    DevelopmentSerializer.new(@max_team_dev).to_header
  end

  private

    def development_with_largest_team
      @developments.max_by(&:team_membership_count)
    end
end
