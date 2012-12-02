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

  def streak
    return games.count if games_lost.count == 0
    return -games.count if games_won.count == 0

    last_game_won = games_won.order('created_at desc').first.created_at
    last_game_lost = games_lost.order('created_at desc').first.created_at

    if last_game_won > last_game_lost
      return games_won.newer_than(last_game_lost).count
    else
      return -games_lost.newer_than(last_game_won).count
    end

  end

  def reset_rating
    self.rating = ranking_algorithm::DEFAULT_PLAYER_RATING
  end

  def rating
    read_attribute(:rating) || ranking_algorithm::DEFAULT_PLAYER_RATING
  end

  def initial_history
    initial = RatingHistory.new
    initial.player = self
    initial.rating = ranking_algorithm::DEFAULT_PLAYER_RATING
    initial
  end
end
