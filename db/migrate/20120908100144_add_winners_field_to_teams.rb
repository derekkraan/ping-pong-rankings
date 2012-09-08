class AddWinnersFieldToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :winners, :boolean
    add_index :teams, :winners
  end
end
