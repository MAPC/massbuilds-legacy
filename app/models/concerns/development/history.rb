class Development
  module History

    def history
      edits.applied
    end

    def contributors
      ContributorQuery.new(self).find.map(&:editor).push(creator).compact.uniq
    end

    def updated_since?(time = Time.current)
      history.since(time).any? ? true : created_since?(time)
    end

    def last_updated
      time = history.any? ? history.first.applied_at : created_at
      time.to_s(:subject)
    end

    def created_since?(time = Time.current)
      created_at > time
    end

    OUT_OF_DATE_THRESHHOLD = 6.months.ago

    def out_of_date?
      !updated_since? OUT_OF_DATE_THRESHHOLD
    end

  end
end
