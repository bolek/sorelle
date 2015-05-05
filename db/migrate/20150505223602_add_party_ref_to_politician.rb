class AddPartyRefToPolitician < ActiveRecord::Migration
  def change
    add_reference :politicians, :party, index: true, foreign_key: true
  end
end
