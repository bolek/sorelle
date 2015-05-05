class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :fec_number, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps null: false
    end

    add_index :politicians, :fec_number, unique: true
  end
end
