class GamesController < ApplicationController
  def show
  end

  def new
    @game = Game.new
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to '/ranking'
    else
      render 'save_fail'
    end
  end

  def create
    game = Game.new(params['game'])

    if game.save
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

