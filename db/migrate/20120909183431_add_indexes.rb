class AddIndexes < ActiveRecord::Migration
  def change
    add_index :games, :created_at
    add_index :games, :updated_at

    add_index :players, :rating
    add_index :players, :created_at
    add_index :players, :updated_at

    add_index :players_teams, :team_id
    add_index :players_teams, :player_id

    add_index :rating_histories, :game_id
    add_index :rating_histories, :player_id

    add_index :teams, :game_id
  end
end
