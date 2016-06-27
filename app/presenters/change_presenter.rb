class ChangePresenter < Burgundy::Item

  # TODO: Rename method to #message, and employ in views.
  def text
    text_for(item)
  end

  private

  def text_for(change)
    types = [change.from.class, change.to.class]
    # TODO: Instead of deleting NilClass, prevent it from ever appearing.
    types.delete NilClass
    template_for(types.first.name.to_sym)
  end

  # TODO: For enumerized values such as 'status', titleize the status value.
  #   For example, when someone changes item.status to :in_construction, the
  #   message should read, 'changed status from "Planning" to "In Construction"'.
  #   This could happen in a conditional here, or it might be possible to do
  #   something in the Development enumerize line.

  # TODO: Let the message values be double-quoted, that is:
  #   'changed name from "old" to "new"'.

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

  # TODO: Does this need to be private?
  def name
    Development.human_attribute_name item.name
  end
end
