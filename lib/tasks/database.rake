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
    broken_developments = Development.where(
    'fa_ret + fa_ofcmd + fa_indmf + fa_whs +
    fa_rnd + fa_edinst + fa_other + fa_hotel != commsf'
    )

    broken_developments.each do |development|
      development_to_fix = Development.find(development.id)
      Rails.logger.info "Updating Development #{development.name}"
      development_to_fix.update_attribute(:fa_ret, development_to_fix.fa_ret * 100)
      development_to_fix.update_attribute(:fa_ofcmd, development_to_fix.fa_ofcmd * 100)
      development_to_fix.update_attribute(:fa_indmf, development_to_fix.fa_indmf * 100)
      development_to_fix.update_attribute(:fa_whs, development_to_fix.fa_whs * 100)
      development_to_fix.update_attribute(:fa_rnd, development_to_fix.fa_rnd * 100)
      development_to_fix.update_attribute(:fa_edinst, development_to_fix.fa_edinst * 100)
      development_to_fix.update_attribute(:fa_other, development_to_fix.fa_other * 100)
      development_to_fix.update_attribute(:fa_hotel, development_to_fix.fa_hotel * 100)
    end
  end

  desc 'Update developments with fixes from Nick'
  task update_developments: :environment do
    csv_text = File.read(Rails.root.join('db', 'import', 'update_massbuilds_data_changes.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each_with_index do |row, index|
      development = Development.find(row['id'])
      development.name = row['name']
      development.address = row['address']
      development.singfamhu = row['singfamhu'].try(:to_i)
      development.commsf = row['commsf'].try(:to_i)
      development.desc = row['_desc']
      development.status = row['status']
      development.year_compl = row['year_compl'].to_i
      development.tothu = row['tothu'].try(:to_i)
      development.hotelrms = row['hotelrms'].try(:to_i)
      development.onsitepark = row['onsitepark'].try(:to_i)
      development.cancelled = row['cancelled'] == 'TRUE' ? true : false
      development.save(validate: false)
    end
  end
end
