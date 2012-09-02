class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  belongs_to :game

  attr_accessible :score

  def self.winning_score
    maximum(:score)
  end

  def self.losing_score
    minimum(:score)
  end
end
