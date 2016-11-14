require 'test_helper'

class DevelopmentValidationTest < ActiveSupport::TestCase

  test 'requires housing units and commercial square feet' do
    d.tothu = d.commsf = nil
    refute d.valid?
    d.tothu = d.commsf = 0
    assert d.valid?, d.errors.full_messages
  end

  test 'requires extra housing information' do
    # If it's in construction or completed, and there's more than
    # one housing unit, require extra housing information.
    housing_fields = Development::HOUSING_FIELDS

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu  = 1
      d.commsf = 0
      housing_fields.each { |attrib| d.send("#{attrib}=", nil) }
      refute d.valid?
      housing_fields.each { |attrib| d.send("#{attrib}=", 0) }
      d.singfamhu = 1 # for sum validation
      assert d.valid?, d.errors.full_messages
    end

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu = d.commsf = 0
      housing_fields.each { |attrib| d.send("#{attrib}=", nil) }
      assert d.valid?, d.errors.full_messages
    end
  end

  test 'requires extra nonres information if in_construction or completed' do
    nonres_fields = Development::COMMERCIAL_FIELDS

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu  = 0
      d.commsf = 1
      nonres_fields.each { |attrib| d.send("#{attrib}=", nil) }
      refute d.valid?
      nonres_fields.each { |attrib| d.send("#{attrib}=", 0) }
      d.fa_ret = 1 # For sum validation
      assert d.valid?, d.errors.full_messages
    end

    [:in_construction, :completed].each do |status|
      d.status = status
      d.tothu = d.commsf = 0
      nonres_fields.each { |attrib| d.send("#{attrib}=", nil) }
      assert d.valid?, d.errors.full_messages
    end
  end

  test 'housing units must add up' do
    d.status = :in_construction
    d.tothu  = 100
    d.commsf = d.gqpop = 0
    d.singfamhu = d.twnhsmmult = d.lgmultifam = 0
    refute d.valid?
    d.singfamhu = 100
    assert d.valid?, d.errors.full_messages
    d.singfamhu = d.twnhsmmult = 25
    d.lgmultifam = 50
    assert d.valid?, d.errors.full_messages
  end

  test 'commercial square feet must add up' do
    d.status = :in_construction
    d.tothu = 0
    d.commsf = 1000

    d.fa_ret    = 0
    d.fa_ofcmd  = 0
    d.fa_indmf  = 0
    d.fa_whs    = 0
    d.fa_rnd    = 0
    d.fa_edinst = 0
    d.fa_other  = 0
    d.fa_hotel  = 0

    refute d.valid?
    d.fa_ret = 1000
    assert d.valid?, d.errors.full_messages
    d.fa_ret = d.fa_ofcmd = d.fa_hotel = d.fa_other = 250
    assert d.valid?, d.errors.full_messages
  end

end
