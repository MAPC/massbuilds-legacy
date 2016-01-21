class DevelopmentTeamSerializer

  # Use inside DevelopmentSerializer
  def initialize(development, max_team_size)
    @development   = development
    @max_team_size = max_team_size
    @row = Array.new(@max_team_size * team_attributes_count)
  end

  def to_row
    # Get attributes from all of the team members
    values = @development.team_members.map {|team_member|
      team_attributes.map{|a| team_member.attributes[a] }
    }.flatten
    # then apply them to the nil-filled row
    values.each_with_index {|v, i| @row[i] = v }
    @row # and return the row
  end

  def to_header
    @max_team_size.times.map{|id|
      header_template(id+1) # #times is 0-index, we want 1-index
    }.flatten
  end

  private

    def header_template(id)
      team_attributes.map{|attrib| "team_member_#{id}_#{attrib}"}
    end

    def team_attributes
      Organization.attribute_names - %w(id creator_id created_at updated_at)
    end

    def team_attributes_count
      team_attributes.count
    end
end

