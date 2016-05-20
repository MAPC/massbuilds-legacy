class Development
  module History

    def history
      edits.applied
    end

    def contributors
      ContributorQuery.new(self).find.map(&:editor).push(creator).uniq
    end

    def updated_since?(time = Time.now)
      history.since(time).any? ? true : created_since?(time)
    end

    def created_since?(time = Time.now)
      created_at > time
    end

    OUT_OF_DATE_THRESHHOLD = 6.months.ago

    def out_of_date?
      !updated_since?(OUT_OF_DATE_THRESHHOLD)
    end

  end
end
