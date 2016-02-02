require 'test_helper'

class TaglineGeneratorTest < ActiveSupport::TestCase
  def generator
    @_generator ||= TaglineGenerator.new(developments(:one))
  end
  alias_method :gen, :generator

  def source
    generator.source
  end

  def perform
    generator.perform!
  end

  test 'performed' do
    assert_match /luxury hotel/i, perform
  end

end
