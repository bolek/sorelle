namespace :etl do

  require "csv"

  desc "load politicians, parties"
  task :load_politicians => :environment do
    path = "lib/assets/20150505_politicians.csv"
    raise "File #{path} not found" unless File.exist?(path)

    db.create_table :tmp_politicians, temp: true do
      Integer :id
      String :fec_number
      String :first_name
      String :last_name
      String :party
      String :party_code
      String :office
      String :office_code
      String :office_state
      String :office_state_code
      String :office_city
      String :office_zip
      String :office_district
      Integer :election_yr
      Integer :rpt_yr
      String :receipt_dt
      Integer :seat_id
    end

    f = File.new(path)
    f.readline("\r")

    db.copy_into(:tmp_politicians, format: :csv, columns: [:id, :fec_number, :first_name, :last_name, :party, :party_code, :office, :office_code, :office_state, :office_state_code, :office_city, :office_zip, :office_district, :election_yr, :rpt_yr, :receipt_dt, :seat_id]) do
      f.eof? ? nil : f.readline("\r")
    end

    now = Sequel.function(:NOW)
    tmp_tbl = db[:tmp_politicians]
    tmp_tbl.where(party: "Unknown").update(party_code: "UNK")

    db[:parties].insert(
      [:name, :code, :created_at, :updated_at],
      tmp_tbl.select(:party, :party_code, now, now).distinct(:party, :party_code)
    )

    db[%(
      INSERT INTO politicians(fec_number, first_name, last_name, party_id, created_at, updated_at)
        SELECT DISTINCT
          fec_number,
          LAST_VALUE(first_name) OVER (PARTITION BY fec_number),
          LAST_VALUE(last_name) OVER (PARTITION BY fec_number),
          LAST_VALUE(p.id) OVER (PARTITION BY fec_number),
          NOW(), NOW()
        FROM tmp_politicians tp
          INNER JOIN parties p ON p.code = tp.party_code;
    )].insert
  end

  def db
    @db ||= Sequel.postgres(Rails.configuration.database_configuration[Rails.env])
  end
end
