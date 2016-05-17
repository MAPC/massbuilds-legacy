class EmploymentEstimator

  def initialize(subject)
    @subject = subject
  end

  def estimate
    breakdown.values.reduce(:+) || 0
  end

  def breakdown
    array = multipliers.each_pair.map do |category, sqft_per_employee|
      if sqft = @subject.send(category)
        [category, sqft * (1 / sqft_per_employee)]
      end
    end.compact
    Hash[array]
  end

  private

  DEFAULT_OTHER_USE_RATE = 150

  def multipliers
    {
      fa_ret:    750,
      fa_ofcmd:  330,
      fa_indmf:  500,
      fa_whs:    750,
      fa_rnd:    330,
      fa_edinst: 330,
      hotelrms:  0.5,
      fa_other:  other_multiplier
    }
  end

  def other_multiplier
    @subject.other_rate || DEFAULT_OTHER_USE_RATE
  end

end
