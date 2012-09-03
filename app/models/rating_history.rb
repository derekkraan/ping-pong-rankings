class RatingHistory < ActiveRecord::Base
  belongs_to :game, dependent: :destroy
  belongs_to :player, dependent: :destroy

  def self.chronological_order
    g = Game.arel_table
    includes(:game).order(g[:created_at].asc)
  end
end
