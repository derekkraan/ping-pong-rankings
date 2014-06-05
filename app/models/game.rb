class Game < ActiveRecord::Base
  include LoadRankingAlgorithm

  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :rating_histories, dependent: :destroy
  after_create :calculate_player_rankings

  def valid?(context = nil)
    # Need to have at least two players
    logger.debug 'Need to have at least two players'
    return false unless teams.all?{ |team| team.players.present? }

    # Need to have a score for each team
    logger.debug 'Need to have a score for each team'
    return false unless teams.all{ |team| team.score.present? }

    # Not the same score for both players
    return false if teams.first.score == teams.second.score

    # If one team has two players, then the other team should too
    logger.debug 'If one team has two players, then the other team should too'
    return false if teams.one?{ |team| team.players.count == 2 }

    # Make sure all players are unique
    logger.debug 'Make sure all players are unique'

    return false unless (pls = teams.reduce([]){ |x,y| x + y.players.map(&:id) }).uniq.count == pls.count

    logger.debug 'Validation OKAY'
    true
  end

  def self.within_last_month
    where(arel_table[:created_at].gt 30.days.ago)
  end

  def self.chronological_order
    order('created_at ASC')
  end

  def self.newest_first
    order('created_at DESC')
  end

  def winning_team
    teams.where(winners: true).first
  end

  def losing_team
    teams.where(winners: false).first
  end

  def winners
    winning_team.players
  end

  def losers
    losing_team.players
  end

  def winning_score
    winning_team.score
  end

  def losing_score
    losing_team.score
  end

  def self.newer_than(time)
    game = Game.arel_table
    where(game[:created_at].gt(time))
  end

  def calculate_player_rankings
    high_score = teams.map(&:score).max
    teams.each { |t| t.winners = (t.score == high_score); t.save }
    ranking_algorithm.calculate(self)
    record_rating_histories
  end

  def record_rating_histories
    players.each do |player|
      if history = rating_histories.where(player_id: player.id).first
        history.rating = player.rating
        history.save
      else
        history = RatingHistory.new
        history.player = player
        history.rating = player.rating
        history.game = self
        history.save
      end
    end
  end

  def self.recalculate_all
    players = Player.all
    players.each(&:reset_rating)
    players.each(&:save)

    self.order('created_at asc').each(&:calculate_player_rankings)
  end
end
