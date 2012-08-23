class EloRanking
  # http://en.wikipedia.org/wiki/Elo_rating_system
  DEFAULT_PLAYER_RATING = 1500

  def self.calculate(t1_score, t2_score, t1_p1, t1_p2, t2_p1, t2_p2)
    # For now just do the one on one case.
    if t1_p1.present? && t2_p1.present? && t1_p2.blank? && t2_p2.blank?

      p1_expected = self.expected_score(t1_p1.rating, t2_p1.rating)
      p2_expected = self.expected_score(t2_p1.rating, t1_p1.rating)

      p1_score = t1_score > t2_score ? 1 : 0
      p2_score = t1_score < t2_score ? 1 : 0

      t1_p1.rating = t1_p1.rating + self.k_factor(t1_p1) * ( p1_score - p1_expected)
      t1_p1.save

      t2_p1.rating = t2_p1.rating + self.k_factor(t2_p1) * ( p2_score - p2_expected)
      t2_p1.save

    end
  end

  def self.expected_score(p1_rating, p2_rating)
    1.0 / (1 + 10**((p2_rating - p1_rating)/400))
  end

  def self.k_factor(player)
    # USCF rules for determining K-factor (higher value means more responsive to recent wins / losses)
    return 32 if player.rating < 2100
    return 24 if player.rating < 2400
    16
  end
  
end
