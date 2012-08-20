class Game < ActiveRecord::Base
  belongs_to :team1_player1, class_name: 'Player'
  belongs_to :team1_player2, class_name: 'Player'
  belongs_to :team2_player1, class_name: 'Player'
  belongs_to :team2_player2, class_name: 'Player'
  attr_accessible :score_difference, :score_team1, :score_team2

  def valid?
    # Need to have at least two players
    return false unless team1_player1 && team2_player1

    # Need to have a score for each team
    return false unless score_team1 && score_team2

    # If one team has two players, then the other team should too
    return false if (team1_player2 && !team2_player2) || (team2_player2 && !team1_player2)

    # Make sure all players are unique
    return false if players.count != players.uniq.count

    true
  end

  def players
    [team1_player1, team1_player2, team2_player1, team2_player2].find_all &:present?
  end
end
