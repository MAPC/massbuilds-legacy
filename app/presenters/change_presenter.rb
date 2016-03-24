class ChangePresenter < Burgundy::Item

  def text
    text_for(item)
  end

  private

  def text_for(change)
    types = [change.from.class, change.to.class]
    types.delete NilClass
    template_for(types.first.name.to_sym)
  end

  # TODO: Make this return an object, for the template
  # to lay out and interpolate text.
  # TODO: For enumerized statuses, instead of just checking
  # that it's String type, titleize values. That is, in_construction,
  # should read In Construction.
  def template_for(type)
    case type
    when :Fixnum
      "changed #{name} from #{from.to_i} to #{to.to_i}"
    when :Float
      "changed #{name} from #{from.to_f} to #{to.to_f}"
    when :TrueClass, :FalseClass
      "set #{name} to #{to.to_b}"
    when :String
      "changed #{name} from '#{from}' to '#{to}'"
    else
      raise ArgumentError, "unexpected type: #{type}"
    end
  end

  def name
    Development.human_attribute_name item.name
  end
end
