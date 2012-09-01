class AddTeamsScores < ActiveRecord::Migration
  def up
    create_table :teams do |t|
      t.references :game
      t.integer :score
      t.timestamps
    end

    create_table :players_teams do |s|
      s.references :team
      s.references :player
      s.timestamps
    end

    execute "INSERT INTO teams (game_id, created_at, score, updated_at) SELECT id AS game_id, created_at, team1_score, NOW() AS score FROM games"
    execute "INSERT INTO teams (game_id, created_at, score, updated_at) SELECT id AS game_id, created_at, team2_score, NOW() AS score FROM games"

    execute "INSERT INTO players_teams (team_id, player_id, created_at, updated_at) SELECT t.id AS team_id, g.team1_player1_id AS player_id, g.created_at AS created_at, NOW() FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team1_score"
    execute "INSERT INTO players_teams (team_id, player_id, created_at, updated_at) SELECT t.id AS team_id, g.team1_player2_id AS player_id, g.created_at AS created_at, NOW() FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team1_score"

    execute "INSERT INTO players_teams (team_id, player_id, created_at, updated_at) SELECT t.id AS team_id, g.team2_player1_id AS player_id, g.created_at AS created_at, NOW() FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team2_score"
    execute "INSERT INTO players_teams (team_id, player_id, created_at, updated_at) SELECT t.id AS team_id, g.team2_player2_id AS player_id, g.created_at AS created_at, NOW() FROM games g, teams t WHERE g.id = t.game_id AND t.score = g.team2_score"

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
