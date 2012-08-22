class Game < ActiveRecord::Base
  belongs_to :team1_player1, class_name: 'Player'
  belongs_to :team1_player2, class_name: 'Player'
  belongs_to :team2_player1, class_name: 'Player'
  belongs_to :team2_player2, class_name: 'Player'
  attr_accessible :ranking_impact, :team1_score, :team2_score, :team1_player1_id, :team1_player2_id, :team2_player1_id, :team2_player2_id

  include LoadRankingAlgorithm

  after_save :calculate_player_rankings

  def valid?(context=nil)
    # Need to have at least two players
    return false unless team1_player1 && team2_player1

    # Need to have a score for each team
    return false unless team1_score && team2_score

    # If one team has two players, then the other team should too
    return false if (team1_player2 && !team2_player2) || (team2_player2 && !team1_player2)

    # Make sure all players are unique
    return false if players.count != players.uniq.count

    true
  end

  def players
    [team1_player1, team1_player2, team2_player1, team2_player2].find_all &:present?
  end

  def winners
    if team1_score > team2_score
      [team1_player1, team1_player2].find_all &:present?
    else
      [team2_player1, team2_player2].find_all &:present?
    end
  end

  def losers
    players - winners
    #if team1_score < team2_score
    #  [team1_player1, team1_player2].find_all &:present?
    #else
    #  [team2_player1, team2_player2].find_all &:present?
    #end
  end

  def winning_score
    [team1_score, team2_score].max
  end

  def losing_score
    [team1_score, team2_score].min
  end

  def calculate_player_rankings
    ranking_algorithm.calculate(team1_score, team2_score, team1_player1, team1_player2, team2_player1, team2_player2)
  end
end
