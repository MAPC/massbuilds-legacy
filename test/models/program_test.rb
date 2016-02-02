require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  def program
    @program ||= programs :forty_b
  end

  test 'valid' do
    assert program.valid?
  end

  test 'requires a name' do
    program.name = nil
    assert_not program.valid?
  end

  test 'requires a description' do
    program.description = nil
    assert_not program.valid?
  end

  test 'requires a type' do
    program.description = nil
    assert_not program.valid?
  end

  test 'requires a valid type' do
    [:regulatory, :incentive].each do |type|
      program.type = type
      assert program.valid?
    end
    [:random, :types].each do |type|
      program.type = type
      assert_not program.valid?
    end
  end

  test 'type predicates' do
    [:regulatory?, :incentive?].each { |type|
      assert_respond_to program, type
    }
  end

  test 'takes a URL' do
    program.url = nil
    assert program.valid?
  end

  test 'sorts by sort order' do
    massworks = programs(:massworks)
    assert_equal massworks, Program.first
  end
end
