module Periscope

  # For every attribute name given in scope_names, define a scope on the model
  # that will accept either a range of numeric values or a single numeric value.
  def ranged_scopes(*scope_names)
    scope_names.map(&:to_sym).each do |name|
      scope name, range_or_value_scope(name)
    end
    scope_accessible(*scope_names, parser: periscope_range_parser)
  end

  # For every attribute name given in scope_names, define a scope on the model
  # that will look up whether the attribute is true, false, or nil, defaulting
  # to true.
  def boolean_scopes(*scope_names)
    scope_names.map(&:to_sym).each do |name|
      scope name, _boolean_scope(name)
    end
    scope_accessible(*scope_names)
  end

  alias_method :ranged_scope,  :ranged_scopes
  alias_method :boolean_scope, :boolean_scopes

  private

  # Assign a scope that accepts either a single numeric value or a range.
  # If a 'max' value is present, the scope will query the range, like
  #   WHERE NUMERIC_VALUE BETWEEN 100 AND 200
  # Otherwise, if there is only one value, it will look up the value, like
  #   WHERE NUMERIC_VALUE = 100
  def range_or_value_scope(name)
    Proc.new do |min, max|
      max ? where(name => min..max) : where(name => min)
    end
  end

  # Assign a scope that will accept a boolean value, and defaults to true if
  # the attribute name is present in the Periscope query.
  # TODO: It might be more reliable to cast this to a boolean before working
  #   with it, but this is a good first pass.
  def _boolean_scope(name)
    Proc.new do |*bools|
      if [false, nil].include? bools.first.to_b
        where(name => [false, nil])
      else
        where(name => true)
      end
    end
  end

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
