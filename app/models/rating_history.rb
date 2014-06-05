class RatingHistory < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def self.chronological_order
    joins(:game).order(Game.arel_table[:created_at].asc)
  end

  def self.newest_first
    joins(:game).order(Game.arel_table[:created_at].desc)
  end

  def self.within_last_month
    joins(:game).where(Game.arel_table[:created_at].gt 30.days.ago)
  end

  def self.last_per_day
    sql = joins(:game).group('date(games.created_at)').select(arel_table[:id].maximum).to_sql
    ids = ActiveRecord::Base.connection.execute("SELECT r.max_id FROM (#{sql}) AS r").map { |r| r.map &:second }.flatten
    self.where(id: ids).chronological_order.joins(:game)
  end

  def created_at
    game.created_at
  end
end
