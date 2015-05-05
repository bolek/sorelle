class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps null: false
    end
    add_index :parties, :name, unique: true
    add_index :parties, :code, unique: true
  end
end
