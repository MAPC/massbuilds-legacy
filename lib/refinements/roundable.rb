module Roundable
  refine Numeric do
    def round_up(nearest=10)
      self % nearest == 0 ? self : self + nearest - (self % nearest)
    end

    def round_down(nearest=10)
      self % nearest == 0 ? self : self - (self % nearest)
    end
  end
end
