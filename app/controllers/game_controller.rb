class GameController < ApplicationController
  def show
  end

  def new
  end

  def save
    new_game = Game.new(params['game'])

    view = new_game.save ? 'save' : 'save_fail'

    render view
  end
end

