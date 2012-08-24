class EloRanking
  # http://en.wikipedia.org/wiki/Elo_rating_system
  DEFAULT_PLAYER_RATING = 1500

  def self.calculate(t1_score, t2_score, t1_p1, t1_p2, t2_p1, t2_p2)

    t1 = [t1_p1, t1_p2].select &:present?
    t2 = [t2_p1, t2_p2].select &:present?

    t1_rating = (t1.map(&:rating).inject(&:+)).to_f / t1.count
    t2_rating = (t2.map(&:rating).inject(&:+)).to_f / t2.count

    t1_expected = self.expected_score(t1_rating, t2_rating)
    t2_expected = 1 - t1_expected #self.expected_score(t2_rating, t1_rating)

    puts 'expected ' << [t1_expected, t2_expected].inspect

    t1_result = t1_score > t2_score ? 1 : 0
    t2_result = t1_score < t2_score ? 1 : 0

    puts 'score - expected ' << [t1_result - t1_expected, t2_result - t2_expected].inspect

    t1.each do |player|
      player.rating = player.rating + self.k_factor(player) * (t1_result - t1_expected)
      player.save
    end

    t2.each do |player|
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
