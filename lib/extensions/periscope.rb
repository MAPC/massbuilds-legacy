module Periscope

  def ranged_scopes(*scope_names)
    scope_names.each do |name|
      scope name.to_sym, Proc.new { |min, max|
        if max
          where(name.to_sym => min..max)
        else
          where(name.to_sym => min)
        end
      }
    end
    scope_accessible(*scope_names, parser: periscope_range_parser)
  end

  def boolean_scopes(*scope_names)
    scope_names.each do |name|
      scope name.to_sym, Proc.new { |*bool| where(name.to_sym => (bool.first.to_s.presence || :true)) }
    end
    scope_accessible(*scope_names)
  end

  alias_method :ranged_scope,  :ranged_scopes
  alias_method :boolean_scope, :boolean_scopes

  private

  def periscope_range_parser
    # Expects a numeric array [min,max] or a string '[min,max]'
    Proc.new do |range|
      array = range.to_s.delete('[ ]').split(',')
      if array.length < 2
        array.first
      else
        array
      end
    end
  end

end
