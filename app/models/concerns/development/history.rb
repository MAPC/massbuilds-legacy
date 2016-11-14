class Development
  module History

    def history
      edits.applied
    end

    # N+1 query (`editors` triggers a second call),
    # but a big improvement over the last iteration.
    def contributors
      User.where(id: editors.pluck(:id) << creator_id)
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

    # TODO: Make this configurable through admin
    OUT_OF_DATE_THRESHHOLD = 6.months.ago

    def out_of_date?
      !updated_since? OUT_OF_DATE_THRESHHOLD
    end

  end
end
