class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :score_team1
      t.integer :score_team2
      t.references :team1_player1
      t.references :team1_player2
      t.references :team2_player1
      t.references :team2_player2
      t.integer :ranking_impact

      t.timestamps
    end
    add_index :games, :team1_player1_id
    add_index :games, :team1_player2_id
    add_index :games, :team2_player1_id
    add_index :games, :team2_player2_id
  end
end
