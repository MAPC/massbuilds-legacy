namespace :database do
  desc 'Correction of sequences id'
  task correction_seq_id: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  desc 'Change nil square footage values to 0'
  task update_nil_sq_ft: :environment do
    Development.where(fa_ret: nil).update_all(fa_ret: 0)
    Development.where(fa_ofcmd: nil).update_all(fa_ofcmd: 0)
    Development.where(fa_indmf: nil).update_all(fa_indmf: 0)
    Development.where(fa_whs: nil).update_all(fa_whs: 0)
    Development.where(fa_rnd: nil).update_all(fa_rnd: 0)
    Development.where(fa_edinst: nil).update_all(fa_edinst: 0)
    Development.where(fa_other: nil).update_all(fa_other: 0)
    Development.where(fa_hotel: nil).update_all(fa_hotel: 0)
  end

  desc 'Fix incorrect commercial square footage numbers'
  task fix_commercial_sq_ft: :environment do
    Development.where(
    'fa_ret + fa_ofcmd + fa_indmf + fa_whs +
    fa_rnd + fa_edinst + fa_other + fa_hotel != commsf'
    ).to_a.each do |development|
      Rails.logger.info "Updating Development #{development.name}"
      development.fa_ret = development.fa_ret * 100
      development.fa_ofcmd = development.fa_ofcmd * 100
      development.fa_indmf = development.fa_indmf * 100
      development.fa_whs = development.fa_whs * 100
      development.fa_rnd = development.fa_rnd * 100
      development.fa_edinst = development.fa_edinst * 100
      development.fa_other = development.fa_other * 100
      development.fa_hotel = development.fa_hotel * 100
      development.save!
    end
  end
end
