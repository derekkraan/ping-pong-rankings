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
    games.where(teams: { winners: true })
  end

  def games_lost
    games.where(teams: { winners: false })
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
    last_game_lost = (games_lost.order('created_at desc').first || Game.new).created_at
    last_game_won = (games_won.order('created_at desc').first || Game.new).created_at

    losing_streak = games_lost.newer_than(last_game_won).count
    return -losing_streak if losing_streak > 0

    winning_streak = games_won.newer_than(last_game_lost).count
    return winning_streak if winning_streak > 0
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
