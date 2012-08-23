class GameController < ApplicationController
  def show
  end

  def new
  end

  def save
    new_game = Game.new(params['game'])

    if new_game.save
      redirect_to '/ranking'
    else
      render 'save_fail'
    end
  end

  def del
    Game.delete(params['game_id'])
    recalculate
  end

  def recalculate
    players = Player.all
    players.each &:reset_rating
    players.each &:save

    Game.order('created_at asc').each &:calculate_player_rankings
  end

end

