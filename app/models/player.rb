class Player < ActiveRecord::Base
  attr_accessible :name, :score, :twitter
  has_many :games_as_t1p1, foreign_key: 'team1_player1_id', class_name: 'Game'
  has_many :games_as_t1p2, foreign_key: 'team1_player2_id', class_name: 'Game'
  has_many :games_as_t2p1, foreign_key: 'team2_player1_id', class_name: 'Game'
  has_many :games_as_t2p2, foreign_key: 'team2_player2_id', class_name: 'Game'

  include LoadRankingAlgorithm

  before_create :validate_player

  def validate_player
    Player.where(:name => name).exists? ? false : true
  end

  def games
    Game.by_player(id)
  end

  def games_won
    Game.won_by_player(id)
  end

  def games_lost
    Game.lost_by_player(id)
  end

  def winning_streak
    latest_lost = games_lost.maximum(:created_at) || 1.year.ago
    games_won.newer_than(latest_lost).count
  end

  def losing_streak
    latest_won = games_won.maximum(:created_at) || 1.year.ago
    games_lost.newer_than(latest_won).count
  end

  def streak
    return winning_streak if winning_streak > 1
    return -losing_streak if losing_streak > 1
    0
  end

  def reset_score
    self.score = ranking_algorithm::DEFAULT_PLAYER_SCORE
  end
end
