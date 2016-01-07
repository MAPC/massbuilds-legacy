require 'test_helper'

class ProposedEditTest < ActiveSupport::TestCase

  def form
    @_form ||= ProposedEdit.new(developments(:one), current_user: User.first.id)
    @_form.item.assign_attributes(name: "Changed Name", commsf: 1337)
    @_form
  end

  test "valid" do
    assert form.valid?
  end

  test "not persisted" do
    refute form.persisted?
  end

  test "#persist is implemented" do
    assert_nothing_raised { form.save }
  end

  test "saving persists edit" do
    assert_difference 'Edit.count', +1 do
      form.save
    end
  end

  test "saving persists field edits" do
    assert_difference 'FieldEdit.count', +2 do
      form.save
    end
  end

  test "#development" do
    assert form.item
  end

  test "attribute delegation" do
    assert_equal form.item.name, form.name
  end

  test ".model_name" do
    assert_equal 'Development', ProposedEdit.model_name
  end

end
