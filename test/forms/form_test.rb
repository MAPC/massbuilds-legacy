require 'test_helper'

class FormTest < ActiveSupport::TestCase

  def form
    @_form ||= Form.new
  end

  test 'valid' do
    assert form.valid?
  end

  test 'save raises error' do
    assert_raises(NotImplementedError) { form.save }
  end

  test 'not persisted' do
    refute form.persisted?
  end

end
