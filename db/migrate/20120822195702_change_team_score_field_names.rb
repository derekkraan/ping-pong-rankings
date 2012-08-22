class ChangeTeamScoreFieldNames < ActiveRecord::Migration
  def change
    rename_column :games, :score_team1, :team1_score
    rename_column :games, :score_team2, :team2_score
  end
end
