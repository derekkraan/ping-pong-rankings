class Player < ActiveRecord::Base
  attr_accessible :name, :rating, :twitter
  has_and_belongs_to_many :teams
  has_many :games, through: :teams
  has_many :rating_histories, dependent: :destroy

  include LoadRankingAlgorithm

  before_create :validate_player

  def validate_player
    Player.where(:name => name).exists? ? false : true
  end

  def games_won
    Game.won_by_player(self)
  end

  def games_lost
    Game.lost_by_player(self)
  end

  def winning_streak
    latest_lost = games_lost.map(&:created_at).max || 1.year.ago
    games.newer_than(latest_lost).won_by_player(self).count
  end

  def losing_streak
    latest_won = games_won.map(&:created_at).max || 1.year.ago
    games.newer_than(latest_won).lost_by_player(self).count
  end

  def streak
    return winning_streak if winning_streak > 0
    return -losing_streak if losing_streak > 0
    0
  end

  def reset_rating
    self.rating = ranking_algorithm::DEFAULT_PLAYER_RATING
  end

  def rating_histories
    initial = RatingHistory.new
    initial.player = self
    initial.rating = ranking_algorithm::DEFAULT_PLAYER_RATING
    [initial] + super.chronological_order
  end
end
