class AddTeamsScores < ActiveRecord::Migration
  def up
    create_table :teams do |t|
      t.references :game
      t.integer :score
    end

    create_table :players_teams do |s|
      s.references :team
      s.references :player
    end

    execute "INSERT INTO teams (game_id, score) SELECT id AS game_id, team1_score AS score FROM games"
    execute "INSERT INTO teams (game_id, score) SELECT id AS game_id, team2_score AS score FROM games"

    execute "INSERT INTO players_teams (team_id, player_id) SELECT t.id AS team_id, g.team1_player1_id AS player_id FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team1_score"
    execute "INSERT INTO players_teams (team_id, player_id) SELECT t.id AS team_id, g.team1_player2_id AS player_id FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team1_score"

    execute "INSERT INTO players_teams (team_id, player_id) SELECT t.id AS team_id, g.team2_player1_id AS player_id FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team2_score"
    execute "INSERT INTO players_teams (team_id, player_id) SELECT t.id AS team_id, g.team2_player2_id AS player_id FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team2_score"


    remove_column :games, :team1_score
    remove_column :games, :team2_score
    remove_column :games, :team1_player1_id
    remove_column :games, :team1_player2_id
    remove_column :games, :team2_player1_id
    remove_column :games, :team2_player2_id
    remove_column :games, :ranking_impact

  end

  def down
    drop_table :players_teams
    drop_table :teams
  end
end
