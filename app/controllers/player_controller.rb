class PlayerController < ApplicationController
  def new
  end

  def save
    new_player = Player.new(params['player'])
    new_player.reset_score
    new_player.save
  end
end
