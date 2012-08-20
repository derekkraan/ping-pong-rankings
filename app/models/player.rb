class Player < ActiveRecord::Base
  attr_accessible :name
  has_many :games_as_t1p1, foreign_key: 'team1_player1_id', class_name: 'Game'
  has_many :games_as_t1p2, foreign_key: 'team1_player2_id', class_name: 'Game'
  has_many :games_as_t2p1, foreign_key: 'team2_player1_id', class_name: 'Game'
  has_many :games_as_t2p2, foreign_key: 'team2_player2_id', class_name: 'Game'

  def games
    games_as_t1p1 << games_as_t1p2 << games_as_t2p1 << games_as_t2p2
  end
end
