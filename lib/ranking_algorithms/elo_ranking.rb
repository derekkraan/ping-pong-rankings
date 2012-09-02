class EloRanking
  # http://en.wikipedia.org/wiki/Elo_rating_system
  DEFAULT_PLAYER_RATING = 1500

  def self.calculate(game)

    t1 = game.teams.first
    t2 = game.teams.second

    t1_rating = (t1.players.map(&:rating).inject(&:+)).to_f / t1.players.count
    t2_rating = (t2.players.map(&:rating).inject(&:+)).to_f / t2.players.count

    t1_expected = self.expected_score(t1_rating, t2_rating)
    t2_expected = 1 - t1_expected #self.expected_score(t2_rating, t1_rating)

    t1_result = t1.score > t2.score ? 1 : 0
    t2_result = t1.score < t2.score ? 1 : 0

    t1.players.each do |player|
      player.rating = player.rating + self.k_factor(player) * (t1_result - t1_expected)
      player.save
    end

    t2.players.each do |player|
      player.rating = player.rating + self.k_factor(player) * (t2_result - t2_expected)
      player.save
    end

  end

  def self.expected_score(p1_rating, p2_rating)
    1.0 / (1.0 + 10**((p2_rating - p1_rating).to_f/400))
  end

  def self.k_factor(player)
    # USCF rules for determining K-factor (higher value means more responsive to recent wins / losses)
    return 32 if player.rating < 2100
    return 24 if player.rating < 2400
    16
  end
  
end
