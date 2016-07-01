require 'test_helper'

class DevelopmentPresenterTest < ActiveSupport::TestCase

  def presenter
    @_presenter ||= DevelopmentPresenter.new(developments(:one))
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test '#contributors' do
    assert_respond_to pres, :contributors
  end

  test '#recent_history' do
    assert_respond_to pres, :recent_history
  end

  test '#related' do
    assert_respond_to pres, :related
  end

  test '#neighborhood not yet implemented' do
    assert_raises(NotImplementedError) { pres.neighborhood }
  end

  test 'related developments are also wrapped' do
    pres.related.each do |development|
      assert_respond_to development, :recent_history
    end
  end

  test '#team' do
    assert_respond_to pres, :team
  end

  test 'employment with estimated only' do
    item.rptdemp = nil
    item.estemp  = 1000
    assert_equal 1000, pres.employment
  end

  test 'employment with reported only' do
    item.rptdemp = 1001
    item.estemp  = nil
    assert_equal 1001, pres.employment
  end

  test 'employment with estimated and reported uses reported' do
    item.rptdemp = 0
    item.estemp  = 1
    assert_equal 0, pres.employment
  end

  test 'employment works with strings' do
    item.rptdemp = '100'
    item.estemp  = '101'
    assert_equal 100, pres.employment
  end

  test 'employment with nothing given returns nil, not an integer' do
    item.rptdemp = item.estemp = nil
    assert_equal nil, pres.employment
    refute_equal 0,   pres.employment
  end

  test 'tagline' do
    assert_respond_to pres, :tagline
  end

  test 'address' do
    expected = '505 Washington Street, Boston MA 02111'
    assert_equal expected, pres.display_address
  end

  test 'short address' do
    expected = '505 Washington Street, Boston'
    assert_equal expected, pres.display_address(short: true)
  end

  test '#disable_moderation?' do
    assert_not_empty item.edits.pending
    assert_equal false, pres.disable_moderation?
    item.edits.pending.destroy_all
    assert_equal true, pres.disable_moderation?
  end

  test '#pending' do
    assert_equal item.edits.pending, pres.pending
  end

  test '#housing_attributes' do
    assert_equal({ }, pres.housing_attributes)
    item.singfamhu = 1
    refute_empty pres.housing_attributes
    assert_equal({ 'singfamhu' => 1 }, pres.housing_attributes)
  end

end
