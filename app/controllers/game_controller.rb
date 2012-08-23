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
end

