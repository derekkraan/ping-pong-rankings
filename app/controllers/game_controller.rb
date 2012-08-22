class GameController < ApplicationController
  def show
  end

  def new
  end

  def save
    new_game = Game.new(params['game'])
    new_game.save
  end
end

