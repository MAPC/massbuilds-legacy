namespace :database do
  desc 'Correction of sequences id'
  task correction_seq_id: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  desc 'Fix incorrect commercial square footage numbers'
  task fix_commercial_sq_ft: :environment do
    Development.where(
    'fa_ret.to_f + fa_ofcmd.to_f + fa_indmf.to_f + fa_whs.to_f +
    fa_rnd.to_f + fa_edinst.to_f + fa_other.to_f + fa_hotel.to_f != commsf.to_f'
    ).to_a.each do |development|
      Rails.logger.info "Updating Development #{development.name}"
      development.fa_ret = development.fa_ret.to_f * 100
      development.fa_ofcmd = development.fa_ofcmd.to_f * 100
      development.fa_indmf = development.fa_indmf.to_f * 100
      development.fa_whs = development.fa_whs.to_f * 100
      development.fa_rnd = development.fa_rnd.to_f * 100
      development.fa_edinst = development.fa_edinst.to_f * 100
      development.fa_other = development.fa_other.to_f * 100
      development.fa_hotel = development.fa_hotel.to_f * 100
      development.save!
    end
  end
end
