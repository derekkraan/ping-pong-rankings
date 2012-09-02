class RatingHistory < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def self.chronological_order
    g = Game.arel_table
    includes(:game).order(g[:created_at].asc)
  end
end
